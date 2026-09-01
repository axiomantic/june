# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.


type
  CppType = object
    node: NimNode
    nim: NimNode
    ident: string
    cpp: string
    isConst: bool
    isPointer: bool
    isReference: bool
    passAsPointer: bool


proc makeCppType(node: NimNode): CppType {.compiletime.} =
  result = CppType(node: node, nim: newEmptyNode(), ident: "", cpp: "", isConst: false, isPointer: false, isReference: false, passAsPointer: false)

  var realNode = node
  if realNode.kind == nnkIdentDefs:
    result.ident = $realNode[0]
    realNode = realNode[1]

  case realNode.kind:
  of nnkBracketExpr:
    if ($realNode[0] == "constval"):
      result.nim = realNode[1]
      result.cpp = $realNode[1]
      result.isConst = true
    elif ($realNode[0] == "constref"):
      result.nim = realNode[1]
      result.cpp = $realNode[1]
      result.isConst = true
      result.isReference = true
    elif ($realNode[0] == "constptr"):
      # A const reference whose callback receives a pointer. Needed where the
      # referenced type cannot round-trip through a std::function that takes it
      # by value: juce::MouseEvent cannot be assigned, so the conversion from
      # std::function<void(MouseEvent)> has no viable operator=.
      result.nim = realNode[1]
      result.cpp = $realNode[1]
      result.isConst = true
      result.isReference = true
      result.passAsPointer = true
    elif ($realNode[0] == "varref"):
      # A mutable reference. Overriding a virtual whose parameter is not const
      # needs one: Component::paint takes a Graphics&, and declaring the
      # override with a const Graphics& does not match it, so the compiler
      # reports a non-virtual member function marked override.
      result.nim = realNode[1]
      result.cpp = $realNode[1]
      result.isReference = true
      result.passAsPointer = true
    else:
      error "Invalid type definition"

  of nnkEmpty:
    result.nim = newIdentNode("void")
    result.cpp = "void"

  else:
    result.nim = node
    result.cpp = $node


proc toCppString(cppType: CppType): string =
  result = ""
  if cppType.isConst: result &= "const "
  result &= cppType.cpp
  if cppType.isPointer: result &= "*"
  if cppType.isReference: result &= "&"


proc newEmitPragma(s: string): NimNode {.compileTime.} =
  result = newNimNode(nnkPragma)
  result.add(newColonExpr(newIdentNode("emit"), newStrLitNode(s)))


proc juneClassCodegen(class: NimNode, body: NimNode, internalClass: bool, parentNamespace: string = ""): NimNode {.compileTime.} =
  # echo body.astGenRepr

  if class.kind != nnkInfix or not eqIdent(class[0], "of"):
    error "Invalid node: " & class.lispRepr

  let className = $class[1]
  let parentClassName = $class[2]

  # The generated Nim type inherits the binding of the C++ parent. Where the new
  # class takes the parent's own name - JUCEApplication of JUCEApplication - the
  # binding is renamed with an Impl suffix so the two can coexist. Where the
  # names differ, no rename happened and the parent is named as written, which
  # is what lets a class be subclassed without displacing it: CustomComponent
  # derives from Component, and Button stays a Component rather than a sibling.
  let appendType = if internalClass and className == parentClassName: "Impl" else: ""

  # Nim codegen list of functions
  var nimObjectBodyDecl = nnkRecList.newTree()

  # Cpp codegen headers and class
  var cppIncludedHeader = "june_generated_" & parentClassName & ".h"
  var cppGeneratedHeader = "june_generated_" & className & ".h"

  var cppIncludeDefinition = "#pragma once\n\n"
  if not internalClass:
      cppIncludeDefinition &= "#include \"" & cppIncludedHeader & "\"\n"

  var cppClassDefinition = ""
  cppClassDefinition &= "namespace june { using namespace juce;\n\n"
  cppClassDefinition &= "struct " & className & " : " & parentNamespace & "::" & parentClassName & " {\n"
  cppClassDefinition &= "    using " & parentNamespace & "::" & parentClassName & "::" & parentClassName & ";\n\n"

  for node in body.children:
    case node.kind:
    of nnkProcDef:
      var funcName = $node.name
      var funcPointerName = "on" & capitalizeAscii($node.name)
      let formalParams = node[3]

      var returnValue = makeCppType(formalParams[0])
      let hasReturnValue = returnValue.cpp != "void"

      # Nim codegen function parameters
      var nimFunctionMemberName = "CppFunctionObject" & (if hasReturnValue: "R" else: "N") & $(formalParams.len - 1)
      var nimFunctionMemberType = (if hasReturnValue or formalParams.len > 1:
        nnkBracketExpr.newTree ident(nimFunctionMemberName)
      else:
        ident(nimFunctionMemberName))

      if hasReturnValue:
        nimFunctionMemberType.add returnValue.nim

      # Cpp codegen function parameters
      var cppFuncSignature = ""
      var cppFuncPointerSignature = ""
      cppFuncPointerSignature &= "    std::function<" & toCppString(returnValue) & "("
      cppFuncSignature &= "    " & toCppString(returnValue) & " " & funcName & "("

      var index = 0
      var cppFuncPointerCallArgs = ""
      for param in formalParams:
        inc(index); if index == 1: continue

        var argType = makeCppType(param[1])

        # A mutable reference is handed to the callback as a pointer. The
        # std::function would otherwise have to take the reference by value,
        # which does not compile for a non-copyable type such as Graphics, and
        # Nim has no way to spell a reference as a generic argument.
        let passAsPointer = argType.passAsPointer

        # Nim codegen arguments
        if passAsPointer:
          nimFunctionMemberType.add nnkPtrTy.newTree(argType.nim)
        else:
          nimFunctionMemberType.add argType.nim

        # Cpp codegen arguments
        # The std::function takes a non-const pointer even where the override's
        # parameter is const: Nim has no const-pointer type, so `ptr T` is the
        # only thing the callback can be declared with, and the two must match.
        cppFuncPointerSignature &= (if passAsPointer: argType.cpp & "*" else: toCppString(argType))
        cppFuncSignature &= toCppString(argType) & " " & $param[0]
        cppFuncPointerCallArgs &= (
          if passAsPointer and argType.isConst: "const_cast<" & argType.cpp & "*>(&" & $param[0] & ")"
          elif passAsPointer: "&" & $param[0]
          else: $param[0])

        if index < len(formalParams):
          cppFuncPointerSignature &= ", "
          cppFuncSignature &= ", "
          cppFuncPointerCallArgs &= ", "

      # Nim codegen function declaration
      nimObjectBodyDecl.add nnkIdentDefs.newTree(
        nnkPostfix.newTree(
          newIdentNode("*"),
          newIdentNode(funcPointerName)
        ),
        nimFunctionMemberType,
        newEmptyNode()
      )

      # Cpp codegen function declaration
      cppFuncPointerSignature = cppFuncPointerSignature.strip(leading = false) & ")> " & funcPointerName & ";"

      cppFuncSignature &= ") override { if (" & funcPointerName & ") "
      if hasReturnValue: cppFuncSignature &= "return "
      cppFuncSignature &= funcPointerName & "(" & cppFuncPointerCallArgs & "); "
      if hasReturnValue: cppFuncSignature &= " else return {}; "
      cppFuncSignature &= "}"

      cppClassDefinition &= cppFuncPointerSignature & "\n"
      cppClassDefinition &= cppFuncSignature & "\n\n"

    of nnkCall:
      let variableName = $node[0]

      var variableTypeNode = newEmptyNode()
      var variableType: string
      var variableBaseTypeName: string
      var variableDefault: string

      if node[1][0].kind == nnkPtrTy:
        variableType = $node[1][0][0] & "*"
        variableBaseTypeName = $node[1][0][0]
        variableDefault = " = nullptr"
        variableTypeNode = node[1][0]

      elif node[1][0].kind == nnkAsgn:
        if node[1][0][0].kind == nnkPtrTy:
          variableType = $node[1][0][0][0] & "*"
          variableBaseTypeName = $node[1][0][0][0]
          variableDefault = " = nullptr"
          variableTypeNode = node[1][0][0]
        else:
          variableType = $node[1][0][0]
          variableBaseTypeName = $node[1][0][0]
          variableDefault = " = " & $node[1][0][1]
          variableTypeNode = node[1][0][1]

      else:
        variableType = $node[1][0]
        variableBaseTypeName = $node[1][0]
        variableTypeNode = node[1][0]

      # Nim codegen member variable
      nimObjectBodyDecl.add nnkIdentDefs.newTree(
        nnkPostfix.newTree(
          newIdentNode("*"),
          node[0]
        ),
        variableTypeNode,
        newEmptyNode()
      )

      # Cpp codegen include and member variable
      let typeInclude = "\"june_generated_" & variableBaseTypeName & ".h\""
      cppIncludeDefinition &= "#if __has_include(" & typeInclude & ")\n"
      cppIncludeDefinition &= "    #include " & typeInclude & "\n"
      cppIncludeDefinition &= "#endif\n\n"

      cppClassDefinition &= "    " & variableType & " " & variableName & variableDefault & ";\n"

    of nnkVarSection:
      # TODO
      #for n in node.children:
      #  nimObjectBodyDecl.add n
      discard

    of nnkIncludeStmt:
      cppIncludeDefinition &= "#include \"" & $node[0] & "\"\n\n"

    of nnkDiscardStmt:
      continue

    else:
      error "Invalid nodes: " & body.lispRepr

  cppClassDefinition &= "};\n\n"
  cppClassDefinition &= "} // namespace june\n"

  let finalCodeEmission = cppIncludeDefinition & cppClassDefinition
  # The macro runs before the Nim compiler creates the nimcache directory, so
  # the generated header has nowhere to land unless we create it here. The VM
  # only gained a working createDir in Nim 2.0; older versions must shell out.
  when (NimMajor, NimMinor) >= (2, 0):
    createDir(june_cache_dir)
  else:
    discard staticExec("mkdir -p " & quoteShell(june_cache_dir))
  writeFile(june_cache_dir / cppGeneratedHeader, finalCodeEmission)

  result = newStmtList nnkTypeSection.newTree(
    nnkTypeDef.newTree(
      nnkPragmaExpr.newTree(
        nnkPostfix.newTree(
          ident("*"),
          ident(className)
        ),
        nnkPragma.newTree(
          nnkExprColonExpr.newTree(
            ident("importcpp"),
            newLit("june::" & className)
          ),
          nnkExprColonExpr.newTree(
            ident("header"),
            newLit(cppGeneratedHeader)
          )
        )
      ),
      newEmptyNode(),
      nnkObjectTy.newTree(
        newEmptyNode(),
        nnkOfInherit.newTree(
          ident(parentClassName & appendType)
        ),
        nimObjectBodyDecl
      )
    )
  )


macro defineCppClassInternal*(class: untyped, body: untyped) =
  result = juneClassCodegen(class, body, true, parentNamespace="juce")


macro defineCppClass*(class: untyped, body: untyped) =
  result = juneClassCodegen(class, body, false, parentNamespace="june")
