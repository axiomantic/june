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
    # Set only by basescalar, where the std::function's return type and the
    # override's differ. Empty means the two are the same.
    valueCpp: string
    castReturn: bool


# The C++ side of a parameter is spelled with the Nim identifier, which is only
# valid C++ by coincidence. It holds for `bool` and for the bound JUCE classes,
# and breaks for the fixed-width aliases: `cint` is not a C++ type at all, while
# plain `int` and `float` are 64-bit in Nim and 32-bit in C++, so the generated
# std::function would disagree with the one the Nim type produces.
const cppPrimitiveNames = {
  "cint": "int",
  "cuint": "unsigned int",
  "cfloat": "float",
  "cdouble": "double",
  "cchar": "char",
  "cschar": "signed char",
  "cuchar": "unsigned char",
  "cshort": "short",
  "cushort": "unsigned short",
  "clong": "long",
  "culong": "unsigned long",
  "clonglong": "long long",
  "culonglong": "unsigned long long",
  # Nim's untyped pointer. Spelled `pointer` in Nim and `void*` in C++, so the
  # std::function would take a type C++ has never heard of without this.
  "pointer": "void*",
  # The fixed-width names. Nim spells these as its own aliases and C++ knows
  # none of them, so a std::function declared with one does not compile.
  "csize_t": "size_t",
  "int8": "signed char",
  "uint8": "unsigned char",
  "int16": "short",
  "uint16": "unsigned short",
  "int32": "int",
  "uint32": "unsigned int",
  "int64": "long long",
  "uint64": "unsigned long long",
}


proc cppPrimitiveName(name: string): string {.compiletime.} =
  for (nimName, cppName) in cppPrimitiveNames:
    if name == nimName: return cppName
  result = name


# The C++ spelling of a Nim type node. A class template has to be rendered
# rather than stringified: `Rectangle[cint]` is `Rectangle<int>` in C++, and
# $node would produce the Nim form, which does not compile. The generated
# header opens `namespace june { using namespace juce; }`, so a bare JUCE name
# resolves without qualifying it.
# Class templates whose Nim name is not their C++ name. Everything else in the
# bindings keeps the JUCE spelling, so only the std:: wrappers need naming here.
const cppTemplateNames = {
  "UniquePtr": "std::unique_ptr",
  "SharedPtr": "std::shared_ptr",
  "CppVector": "std::vector",
  "CppOptional": "std::optional",
}


# The C++ spelling of a bound Nim type, where the two differ. A nested class is
# named in Nim by its parts joined together - DragAndDropTargetSourceDetails -
# while C++ still spells it DragAndDropTarget::SourceDetails, and writing the
# Nim name into the generated header names a type that does not exist. A
# `cppTypeName Nim, "Cpp::Name"` line in the class body supplies the pairing.
proc cppAliasName(name: string, aliases: seq[(string, string)]): string {.compiletime.} =
  for (nimName, cppName) in aliases:
    if name == nimName: return cppName
  result = ""


proc cppTemplateName(name: string): string {.compiletime.} =
  for (nimName, cppName) in cppTemplateNames:
    if name == nimName: return cppName
  result = cppPrimitiveName(name)


proc cppTypeSpelling(node: NimNode, aliases: seq[(string, string)]): string {.compiletime.} =
  case node.kind:
  of nnkBracketExpr:
    # The head goes through the same lookup as a plain name, so a nested class
    # used as a template head is spelled the way C++ knows it rather than by
    # its flattened Nim name.
    result = cppAliasName($node[0], aliases)
    if result.len == 0:
      result = cppTemplateName($node[0])
    result &= "<"
    for index in 1 ..< node.len:
      if index > 1: result &= ", "
      result &= cppTypeSpelling(node[index], aliases)
    result &= ">"
  of nnkPtrTy:
    result = cppTypeSpelling(node[0], aliases) & "*"
  else:
    result = cppAliasName($node, aliases)
    if result.len == 0:
      result = cppPrimitiveName($node)


proc makeCppType(node: NimNode, aliases: seq[(string, string)] = @[]): CppType {.compiletime.} =
  result = CppType(node: node, nim: newEmptyNode(), ident: "", cpp: "", isConst: false, isPointer: false, isReference: false, passAsPointer: false)

  var realNode = node
  if realNode.kind == nnkIdentDefs:
    result.ident = $realNode[0]
    realNode = realNode[1]

  case realNode.kind:
  of nnkBracketExpr:
    if ($realNode[0] == "constval"):
      result.nim = realNode[1]
      result.cpp = cppTypeSpelling(realNode[1], aliases)
      result.isConst = true
    elif ($realNode[0] == "constref"):
      # Only for a type Nim passes by value. Nim's calling convention hands an
      # object to a C function by pointer, so the raw proc behind a closure
      # taking one has signature void(T*, void*) and bind() deduces
      # std::function<void(T*)> from it. That does not convert to the
      # std::function<void(T)> declared here, and the error surfaces deep inside
      # june_function_utils rather than at the declaration. constptr is the
      # form that works for those, so refuse the combination outright.
      let referencedName = $realNode[1]
      if cppPrimitiveName(referencedName) == referencedName and referencedName != "bool":
        error "constref[" & referencedName & "] cannot be bound: Nim passes " &
              referencedName & " by pointer, so the callback signature would " &
              "not match. Use constptr[" & referencedName & "] instead."
      result.nim = realNode[1]
      result.cpp = cppTypeSpelling(realNode[1], aliases)
      result.isConst = true
      result.isReference = true
    elif ($realNode[0] == "constptr"):
      # A const reference whose callback receives a pointer. Needed where the
      # referenced type cannot round-trip through a std::function that takes it
      # by value: juce::MouseEvent cannot be assigned, so the conversion from
      # std::function<void(MouseEvent)> has no viable operator=.
      result.nim = realNode[1]
      result.cpp = cppTypeSpelling(realNode[1], aliases)
      result.isConst = true
      result.isReference = true
      result.passAsPointer = true
    elif ($realNode[0] == "constrawptr"):
      # A parameter that is already a const pointer in C++, rather than a const
      # reference. The override has to keep the const to match the virtual it
      # overrides, and Nim has no const pointer, so the callback receives a
      # mutable one and the forwarder casts. `constrawptr[pointer]` is the
      # const void* form.
      if $realNode[1] == "pointer":
        result.nim = newIdentNode("pointer")
        result.cpp = "void"
      else:
        result.nim = nnkPtrTy.newTree(realNode[1])
        result.cpp = cppTypeSpelling(realNode[1], aliases)
      result.isConst = true
      result.isPointer = true
      result.passAsPointer = true

    elif ($realNode[0] == "basescalar"):
      # A return type Nim spells as a distinct scalar - every bound JUCE enum is
      # a `distinct cint`. Nim renders one closure struct for `proc(): cint` and
      # `proc(): SomeEnum` and types its function-pointer field from whichever
      # it emits first, so a program that sets one handler of each kind assigns
      # a pointer of the wrong type and C++ rejects it.
      #
      # So the callback returns the base scalar and never names the distinct:
      # the std::function is over `int`, the override keeps the enum to match
      # the virtual, and the forwarder casts the value it got back. The cast is
      # on a value rather than on a function pointer, which is defined.
      result.nim = newIdentNode("cint")
      result.valueCpp = "int"
      result.cpp = cppTypeSpelling(realNode[1], aliases)
      result.castReturn = true

    elif ($realNode[0] == "varref"):
      # A mutable reference. Overriding a virtual whose parameter is not const
      # needs one: Component::paint takes a Graphics&, and declaring the
      # override with a const Graphics& does not match it, so the compiler
      # reports a non-virtual member function marked override.
      result.nim = realNode[1]
      result.cpp = cppTypeSpelling(realNode[1], aliases)
      result.isReference = true
      result.passAsPointer = true
    else:
      # A class template used by value, such as Point[cint] or Range[cint].
      # Nim spells the instantiation directly, so the node itself is the member
      # type and only the C++ side needs rendering.
      result.nim = realNode
      result.cpp = cppTypeSpelling(realNode, aliases)

  of nnkPtrTy:
    # A pointer parameter, such as ChangeListener's ChangeBroadcaster*. Passed
    # through as a pointer on both sides, so nothing needs taking an address of.
    result.nim = realNode
    result.cpp = cppTypeSpelling(realNode[0], aliases)
    result.isPointer = true

  of nnkEmpty:
    result.nim = newIdentNode("void")
    result.cpp = "void"

  else:
    # A plain name: a bound class, or a primitive. Either may be spelled
    # differently in C++, so it goes through the same renderer as the rest.
    result.nim = node
    result.cpp = cppTypeSpelling(realNode, aliases)


proc toCppString(cppType: CppType): string =
  result = ""
  if cppType.isConst: result &= "const "
  result &= cppType.cpp
  if cppType.isPointer: result &= "*"
  if cppType.isReference: result &= "&"


# The spelling used for the stored std::function's own signature. Nim can spell
# neither const nor a reference, so the member type it declares is always the
# bare value (or pointer). The std::function has to be declared the same way or
# the two disagree: the C++ field would be std::function<void(const String&)>
# while Nim believes it is std::function<void(String)>, and every assignment to
# it is rejected by one side or the other. The override itself keeps the const
# reference, because that has to match the virtual it is overriding.
proc toCppValueString(cppType: CppType): string =
  result = (if cppType.valueCpp.len > 0: cppType.valueCpp else: cppType.cpp)
  if cppType.isPointer: result &= "*"


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

  # The C++ parent is normally the Nim parent's name under the namespace, which
  # holds while a binding is named after the class it binds. It does not hold
  # for a type bound through an alias: Slider::Listener is an alias for the
  # class template SliderListener<Slider>, and only the alias can be named. A
  # `cppParent "..."` line in the body gives the spelling to derive from.
  var cppParentSpelling = ""
  for node in body.children:
    if node.kind in {nnkCall, nnkCommand} and node.len == 2 and
       node[0].kind == nnkIdent and $node[0] == "cppParent" and
       node[1].kind == nnkStrLit:
      cppParentSpelling = $node[1]

  # `cppTypeName Nim, "Cpp::Name"` pairs a flattened Nim name with the spelling
  # C++ knows it by.
  var typeAliases: seq[(string, string)] = @[]
  for node in body.children:
    if node.kind in {nnkCall, nnkCommand} and node.len == 3 and
       node[0].kind == nnkIdent and $node[0] == "cppTypeName" and
       node[2].kind == nnkStrLit:
      typeAliases.add(($node[1], $node[2]))

  # Nim codegen list of functions
  var nimObjectBodyDecl = nnkRecList.newTree()

  # Cpp codegen headers and class
  var cppIncludedHeader = "june_generated_" & parentClassName & ".h"
  var cppGeneratedHeader = "june_generated_" & className & ".h"

  # june.h, because the forwarder falls back through june::fallback when no
  # handler is set. The generated header includes only the JUCE module it needs
  # otherwise, and that does not declare it.
  var cppIncludeDefinition = "#pragma once\n\n#include <utility>\n\n#include <june.h>\n\n"
  if not internalClass:
      cppIncludeDefinition &= "#include \"" & cppIncludedHeader & "\"\n"

  var cppClassDefinition = ""
  cppClassDefinition &= "namespace june { using namespace juce;\n\n"
  let cppParent = if cppParentSpelling.len > 0: cppParentSpelling
                  else: parentNamespace & "::" & parentClassName
  cppClassDefinition &= "struct " & className & " : " & cppParent & " {\n"
  # A public forwarding constructor rather than `using Parent::Parent`. An
  # inherited constructor keeps the base's access, and juce::Button's is
  # protected, so the subclass could not be constructed from outside at all.
  cppClassDefinition &= "    template <typename... Args>\n"
  cppClassDefinition &= "    " & className & "(Args&&... args) : " & cppParent & "(std::forward<Args>(args)...) {}\n\n"

  for node in body.children:
    case node.kind:
    of nnkProcDef:
      var funcName = $node.name
      var funcPointerName = "on" & capitalizeAscii($node.name)
      let formalParams = node[3]

      var returnValue = makeCppType(formalParams[0], typeAliases)
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
      cppFuncPointerSignature &= "    std::function<" & toCppValueString(returnValue) & "("
      cppFuncSignature &= "    " & toCppString(returnValue) & " " & funcName & "("

      var index = 0
      var cppFuncPointerCallArgs = ""
      for param in formalParams:
        inc(index); if index == 1: continue

        var argType = makeCppType(param[1], typeAliases)

        # A mutable reference is handed to the callback as a pointer. The
        # std::function would otherwise have to take the reference by value,
        # which does not compile for a non-copyable type such as Graphics, and
        # Nim has no way to spell a reference as a generic argument.
        let passAsPointer = argType.passAsPointer

        # Nim codegen arguments
        if passAsPointer and argType.isPointer:
          # constrawptr's nim node is already the pointer, or `pointer` itself.
          nimFunctionMemberType.add argType.nim
        elif passAsPointer:
          nimFunctionMemberType.add nnkPtrTy.newTree(argType.nim)
        else:
          nimFunctionMemberType.add argType.nim

        # Cpp codegen arguments
        # The std::function takes a non-const pointer even where the override's
        # parameter is const: Nim has no const-pointer type, so `ptr T` is the
        # only thing the callback can be declared with, and the two must match.
        cppFuncPointerSignature &= (if passAsPointer: argType.cpp & "*" else: toCppValueString(argType))
        cppFuncSignature &= toCppString(argType) & " " & $param[0]
        cppFuncPointerCallArgs &= (
          if passAsPointer and argType.isConst and argType.isPointer:
            # Already a pointer, so it is cast rather than addressed.
            "const_cast<" & argType.cpp & "*>(" & $param[0] & ")"
          elif passAsPointer and argType.isConst: "const_cast<" & argType.cpp & "*>(&" & $param[0] & ")"
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

      # `{.cppconst.}` marks an override of a const virtual. Without it the
      # generated method is a different signature from the one it means to
      # override, so C++ treats it as a new non-virtual member and rejects the
      # override marker.
      var isConstMethod = false
      if node[4].kind == nnkPragma:
        for pragma in node[4]:
          if pragma.kind == nnkIdent and eqIdent(pragma, "cppconst"):
            isConstMethod = true
      if isConstMethod: cppFuncSignature &= ") const override { if ("
      else: cppFuncSignature &= ") override { if ("
      cppFuncSignature &= funcPointerName & ") "
      if hasReturnValue:
        cppFuncSignature &= "return "
        if returnValue.castReturn:
          cppFuncSignature &= "(" & returnValue.cpp & ") "
      cppFuncSignature &= funcPointerName & "(" & cppFuncPointerCallArgs & "); "
      # june::fallback rather than `return {}`: a type with no default
      # constructor - juce::Justification, juce::Font - cannot be value
      # initialised, and a look and feel method returning one could not be
      # generated at all.
      if hasReturnValue:
        cppFuncSignature &= " else return june::fallback<" &
                            toCppString(returnValue) & ">(); "
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

    of nnkCommand:
      # cppParent was read above; nothing else is a command here.
      continue

    else:
      error "Invalid nodes: " & body.lispRepr

  cppClassDefinition &= "};\n\n"
  cppClassDefinition &= "} // namespace june\n"

  let finalCodeEmission = cppIncludeDefinition & cppClassDefinition
  # The macro runs before the Nim compiler creates the nimcache directory, so
  # the generated header has nowhere to land unless we create it here.
  createDir(june_cache_dir)
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
