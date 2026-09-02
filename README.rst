.. image:: https://github.com/kunitoki/june/raw/main/logo.png
    :alt: june
    :target: https://github.com/kunitoki/june

.. image:: https://github.com/kunitoki/june/actions/workflows/ci.yml/badge.svg
    :alt: ci
    :target: https://github.com/kunitoki/june/actions/workflows/ci.yml

JUNE is a Nim binding of the JUCE framework, allowing fast prototyping JUCE applications in your favourite
compiled programming language.

------------
Requirements
------------

- Nim 2.2.2 or newer. Up to and including 2.2.0, Nim emits one C++ function for
  a generic over an ``importcpp`` type and reuses it across instantiations, so a
  module holding two ``UniquePtr`` instantiations fails to compile. 1.6, 2.0 and
  2.2.0 are all affected; 2.2.2 is the first release that builds this library.
  CI tests 2.2.2 and 2.2.10, so the stated minimum is the one that is measured.
- CMake 3.22 or newer, Ninja, and a C++17 compiler.
- JUCE 8.0.15, vendored as a git submodule. Clone with ``--recursive``, or run
  ``git submodule update --init --recursive`` in an existing checkout.
- On Linux, the JUCE development packages::

    sudo apt-get install ninja-build pkg-config libfreetype-dev \
      libfontconfig1-dev libx11-dev libxext-dev libxinerama-dev \
      libxrandr-dev libxcursor-dev libxcomposite-dev libcurl4-openssl-dev

-----------------
Build From Source
-----------------

Build the JUCE shared library.

.. code-block:: bash

  nimble juce_debug
  # nimble juce_release


Then run the test suite.

.. code-block:: bash

  nimble test

``nimble`` 0.22 exits 0 whatever happens, including on a task whose ``exec``
raised, so its exit code does not report a failing test. Read its output, or run
the tests directly, which reports properly:

.. code-block:: bash

  (for t in tests/test_juce_*.nim; do nim cpp -r "$t" || exit 1; done)

CI does the latter for this reason.


Compile the examples.

.. code-block:: bash

  nimble examples


Or build and run the example application (tweak nim.cfg if needed).

.. code-block:: bash

  nimble app_debug
  # nimble app_release

-------------------
Example Application
-------------------

A simple example application (subject to changes):

.. code-block:: nim

  import june

  {.emit: """/*INCLUDESECTION*/
  #include <june.h>
  """.}


  defineCppClass TestApplication of JUCEApplication:
      window: ptr DocumentWindow


  proc constructTestApplication*(): TestApplication =
      result = TestApplication()


  proc createApplication(): ptr JUCEApplication =
      var application: ptr TestApplication = cnew constructTestApplication()
      application.window = nil

      application[].onGetApplicationName = bindClosure(proc(): String = "JUNE App")
      application[].onGetApplicationVersion = bindClosure(proc(): String = "0.1")

      application[].onInitialise = bindClosure(proc(commandLine: ptr String) =
          echo "Starting JUNE App " & $commandLine[]

          var windowName = application[].getApplicationName()

          application[].window = newDocumentWindow(windowName, makeColour(50'u8, 62'u8, 68'u8, 255'u8), DocumentWindow_allButtons, true)
          application[].window[].onCloseButtonPressed = bindClosure(proc() = JUCEApplication.getInstance().systemRequestedQuit())
          application[].window[].setResizable(true, true)
          application[].window[].centreWithSize(640, 480)
          application[].window[].setVisible(true)

          echo "Starting JUNE App completed"
      )

      application[].onShutdown = bindClosure(proc() =
          echo "Shutdown JUNE App "

          cdelete(application[].window)
          application[].window = nil

          echo "Shutdown JUNE App completed"
      )

      application[].onSystemRequestedQuit = bindClosure(proc() = application[].quit())

      result = application


  when isMainModule:
      START_JUCE_APPLICATION(createApplication)


Will look like this:

.. image:: https://github.com/kunitoki/june/blob/main/assets/example_app.png?raw=true
    :target: https://github.com/kunitoki/june/blob/main/examples/test_app.nim

-----------------------
Subclassing A Component
-----------------------

``CustomComponent`` is a ``Component`` whose virtual methods call into Nim.

.. code-block:: nim

  import june

  let component = newCustomComponent()
  component[].setBounds(makeRectangle(0.cint, 0.cint, 400.cint, 300.cint))

  component[].setPaintHandler(proc(g: ptr Graphics) =
    g[].setColour(makeColour(50'u8, 62'u8, 68'u8, 255'u8))
    g[].fillRect(component[].getLocalBounds())
  )

  component[].setMouseDownHandler(proc(e: ptr MouseEvent) =
    let p = e[].getPosition()
    echo "clicked at ", p.getX(), ", ", p.getY()
  )

  component[].onResized = bindClosure(proc() = discard)

A handler that takes an argument receives a pointer, because the C++ parameter
is a reference and a ``std::function`` cannot take one by value -- ``Graphics``
is not copyable and ``MouseEvent`` is not assignable.

Set those through ``setPaintHandler`` and ``setMouseDownHandler`` and the rest,
which take a plain Nim closure and name the field's type for you. Assigning the
field directly works too::

  component[].onResized = bindClosure(proc() = discard)

Where the C++ base is named through an alias, name it with ``cppParent``: the
generated subclass has to derive from a spelling C++ accepts, and
``Slider::Listener`` is an alias for the class template
``SliderListener<Slider>``, which cannot be derived from by its Nim name.

.. code-block:: nim

  defineCppClassInternal CustomSliderListener of SliderListener:
      cppParent "juce::Slider::Listener"
      proc sliderValueChanged(slider: ptr Slider) = discard

``CustomButton`` and ``CustomTimer`` work the same way. Both subclass a JUCE
class whose pure virtual made it impossible to instantiate before:
``Button::paintButton`` and ``Timer::timerCallback``.

.. code-block:: nim

  let timer = newCustomTimer()
  timer[].onTimerCallback = bindClosure(proc() = echo "tick")
  timer[].startTimer(1000.cint)

Wrap code that constructs these in ``initialiseJuce_GUI()`` and
``shutdownJuce_GUI()``. A Button starts JUCE's timer thread and its look and
feel singleton, and both assert at exit if the GUI was never initialised.

``bindClosure`` retains the closure's environment for the life of the program.
C++ holds only the raw environment pointer, so without that the environment is
collected as soon as the Nim closure goes out of scope, and the callback then
reads freed memory -- which shows up as a corrupted capture rather than a crash.
The cost is one retained environment per bound closure; callbacks are set up
once, so that is bounded.

To run something on the message thread, bind the closure first and pass it to
``MessageManager.callAsync``:

.. code-block:: nim

  let callback: CppFunctionObjectN0 = bindClosure(proc() = echo "on the message thread")
  discard MessageManager.callAsync(callback)

Where JUCE takes the callback by const reference, bind it with
``bindConstRefClosure`` and declare the argument as a pointer. ``juce::var``'s
native functions are the case that needs it: ``NativeFunctionArgs`` holds a
reference member, so a ``std::function`` over it by value does not compile.

.. code-block:: nim

  let obj = cnew(makeDynamicObject())
  let answer: CppFunctionObjectR1Ref[juce_var, juce_varNativeFunctionArgs] =
    bindConstRefClosure(proc(args: ptr juce_varNativeFunctionArgs): juce_var =
      makejuce_var(7.cint))
  obj[].setMethod(makeIdentifier("answer"), answer)

To run one on a background thread, hand it to a ``ThreadPool``. The job returns
a status, so the pool knows whether to run it again:

.. code-block:: nim

  var pool = makeThreadPool()
  let job: CppFunctionObjectR0[ThreadPoolJobJobStatus] = bindClosure(
    proc(): ThreadPoolJobJobStatus =
      echo "on a pool thread"
      ThreadPoolJobJobStatus_jobHasFinished)
  pool.addJob(job)
  discard pool.removeAllJobs(false, 5000.cint)   # waits for it to finish

Theming With A LookAndFeel
--------------------------

Every JUCE widget asks its ``LookAndFeel`` to draw it, so overriding one method
restyles every widget of that kind at once. ``CustomLookAndFeel`` subclasses
``LookAndFeel_V4``; an override left unset falls through to the V4 drawing.

.. code-block:: nim

  let theme = newCustomLookAndFeel()

  theme[].setDrawRotarySliderHandler(proc(g: ptr Graphics, x, y, width, height: cint,
                                          sliderPos, startAngle, endAngle: cfloat,
                                          slider: ptr Slider) =
    g[].setColour(makeColour(120'u8, 200'u8, 160'u8, 255'u8))
    g[].fillEllipse(x.float32, y.float32, width.float32, height.float32)
  )

  slider[].setLookAndFeel(theme)

``setDrawButtonBackgroundHandler`` and ``setDrawLabelHandler`` are bound the
same way. Clear a widget's look and feel with ``setLookAndFeel(nil)`` before
deleting the theme: a ``Component`` must not outlive the ``LookAndFeel`` it
points at.

``examples/rotary_panel.nim`` puts these together into a complete application --
a window, a themed rotary slider, a label and a timer.

----------------
What Is Bound
----------------

The bindings are generated from the JUCE headers by ``tools/inspect_juce.py``.
Hand-written additions live in the ``*_lifting.nim`` files and in
``june_juce_types.nim``.

- Classes, with their inheritance, so a ``TextButton`` accepts every
  ``Component`` method. Nested classes too, with their own methods and
  constructors, under the name of the class that encloses them:
  ``LookAndFeel_V4::ColourScheme`` is ``LookAndFeel_V4ColourScheme`` and
  ``Image::BitmapData`` is ``ImageBitmapData``. At any depth:
  ``Expression::Scope::Visitor`` is ``ExpressionScopeVisitor``.
- Constructors, as ``make<ClassName>`` procs.
- Free functions in the ``juce`` namespace, including the operators JUCE
  declares there rather than as members: ``String`` concatenation is one, and
  its ``==`` is another.
- Public fields, as a getter and a setter, so ``parameters.startAngleRadians``
  reads and ``parameters.startAngleRadians = x`` writes. A field C++ will not
  let anyone assign -- a const one, or a reference -- gets only the getter.
- Function templates, as Nim generics: ``jlimit``, ``jmax``, ``jmin``,
  ``jmap``, ``degreesToRadians`` and the rest of JUCE's maths helpers. The C++
  compiler deduces the template argument from the call. A deduction guide, a
  non-type parameter, a parameter pack and a SFINAE-constrained signature have
  no Nim generic to become, so those stay comments and say which -- the same
  fallback nimterop and hcparse make, neither of them binding C++ templates
  automatically.
- Conversion operators, as an explicit ``to<Type>`` rather than a Nim
  converter: ``someVar.toInt()``, ``someVar.toFloat64()``,
  ``someResult.toBool()``. An implicit converter would compete with every other
  overload. A method of the same name wins, so ``var``'s own ``toString``
  stays.
- Static member variables, the same way, so ``AffineTransform.identity()`` and
  ``AlertWindow.WarningIcon()`` are reachable. They take call parentheses
  because Nim needs a call-shaped ``importcpp`` pattern.
- Static methods, taking the class as a ``typedesc``, so ``Colour::fromRGB`` is
  ``Colour.fromRGB(r, g, b)`` and ``AffineTransform::rotation`` is
  ``AffineTransform.rotation(angle)``.
- Enums, as distinct integer types. Enumerators are prefixed with the type name:
  ``JustificationFlags_centred``, ``NotificationType_sendNotification``.
- Operators. ``==``, ``<``, ``<=``, ``+``, ``-``, ``*``, ``/`` and ``[]`` are
  bound as Nim operators; ``!=``, ``>`` and ``>=`` follow from them. Compound
  assignment -- ``+=``, ``-=``, ``*=``, ``/=``, ``|=``, ``&=``, ``^=``, ``%=``,
  ``<<=`` and ``>>=`` -- is bound as a statement returning nothing, where C++
  returns a reference to the target. The bitwise operators ``|``, ``&``, ``^``
  and ``%`` keep their spelling; the shifts take Nim's names, ``shl`` and
  ``shr``.
- The class templates: ``Rectangle``, ``Point``, ``Line``, ``BorderSize``,
  ``Range``, ``Array``, ``OwnedArray``, ``Span``, ``RectangleList``,
  ``SparseSet``, ``NormalisableRange``, ``Parallelogram``, ``Optional``,
  ``HeapBlock``, ``WeakReference``, ``OptionalScopedPointer`` and
  ``ReferenceCountedObjectPtr``. ``HeapBlock`` owns its buffer
  and cannot be copied, so Nim rejects a copy of one at compile time.
- Iterators over the containers a caller loops over: ``ValueTree`` children and
  properties, ``StringArray``, ``XmlElement`` children and attributes,
  ``NamedValueSet``,
  ``Array``, ``OwnedArray``, ``Span``, ``RectangleList`` and ``std::vector``.
  JUCE's ``begin`` and ``end`` have no Nim spelling, so these are written over
  the indexed accessors instead.
- The standard library types JUCE exposes: ``std::unique_ptr``,
  ``std::optional``, ``std::vector``, ``std::string``, ``std::map``,
  ``std::unordered_map``, ``std::array``, ``std::byte``, ``std::exception``,
  ``std::type_index`` and ``std::function``.
- Subclasses whose virtual methods call into Nim: ``CustomComponent``,
  ``CustomButton``, ``CustomTimer``, ``CustomAsyncUpdater``,
  ``CustomActionListener``, ``CustomChangeListener``, ``CustomSlider``,
  ``CustomLabel``, ``CustomLookAndFeel``, ``CustomSliderListener`` and
  ``CustomListBoxModel``, plus the
  ``JUCEApplication`` and ``DocumentWindow`` that were already there. Most of those JUCE classes have a
  pure virtual, so they could not be instantiated without a subclass at all.

A ``StringRef`` does not own its characters, exactly as in C++. Building one
from a temporary leaves it pointing at freed memory, and the result is a wrong
answer rather than a crash::

  let bad = makeStringRef(makeString("aa"))   # the String is already gone
  let ok = makeString("aa")
  let good = makeStringRef(ok)                # ok outlives good

Passing a Nim string straight to a ``StringRef`` parameter is safe: the
converter's temporary lives for the duration of the call, which is the same
contract C++ gives.

An enum is a ``distinct cint``, which has none of ``cint``'s operators unless
they are given to it. Each one carries a borrowed ``==`` and ``$``, and the
flag sets -- the enums whose name ends in ``Flags``, which is how JUCE spells a
nested ``Flags`` enum -- also carry ``or`` and ``and``::

  let style = FontFontStyleFlags_bold or FontFontStyleFlags_italic
  if (style and FontFontStyleFlags_bold) == FontFontStyleFlags_bold: discard

``$`` prints the number rather than the name. The binding holds the C++
enumerator and there is no table of names on this side to look one up in.

Instantiate a class template with ``cint`` or ``cfloat``, never Nim's ``int`` or
``float``. Nim puts the parameter's C++ name into the template, and Nim's
``int`` is 64-bit, so ``Rectangle[int]`` asks for a ``juce::Rectangle<long
long>`` that JUCE never instantiates.

A proc that is not bound is emitted as a comment rather than omitted, with the
reason on the same line, so what is missing stays visible in the generated file
and says why. Most of them are not gaps: an ``operator!=``, ``operator>`` or
``operator>=`` is commented because Nim derives it, a ``begin`` or ``end``
because the Nim iterator replaces it, a C array or ``std::initializer_list``
parameter because the same class takes a String, a value or the incremental API
instead, and a handful the generator excludes on purpose, each saying why.

Two reasons do mark a real gap. A ``fixed-size C array member`` is one:
``IPAddress::address`` and ``RelativePointPath``'s control points are only
reachable as the array they are, and unlike a C array *parameter* there is no
overload to go through. The other is a type that cannot be spelled in Nim, each
of which is a C++ shape with no Nim equivalent: a class template used as a value
(``ListenerList<Listener>``, ``SingletonHolder<T>``, ``Tolerance<T>``), a
``std::variant`` or ``std::string_view``, a function template whose return type
is ``auto``, a platform handle such as ``__CFString``, and
``ComponentPeer::setMultimonitorPositionOverride``, which returns a class
declared inside its own function body and so has no name outside it even in
C++. List them with::

  grep -n 'cannot be spelled' sources/june/juce_*.nim

``$`` uses JUCE's ``toString`` where there is one. Nim's own ``$`` prints
``()`` for these, because an ``importcpp`` object declares no fields and there
is nothing to show.

Comparing two values of a type JUCE gives no ``operator==`` is a compile error
naming the type. Nim would otherwise compare an ``importcpp`` object
structurally, and those declare no fields, so it compared nothing and reported
every two values equal.

--------------------------
Regenerating The Bindings
--------------------------

Needed after a JUCE upgrade, or after a change to ``tools/inspect_juce.py``.
The generator reads the JUCE headers with libclang.

.. code-block:: bash

  # A virtual environment, because a system Python refuses --user installs
  # under PEP 668. CI uses --break-system-packages on a throwaway runner.
  python3 -m venv .venv && .venv/bin/pip install libclang

  for module in juce_core juce_events juce_data_structures juce_graphics juce_gui_basics; do
    PYTHONPATH=tools .venv/bin/python tools/inspect_juce.py --module "$module" > "sources/june/$module.nim"
  done

A JUCE class with a pure virtual cannot be constructed, so one with no C++
subclass is unreachable from Nim however completely its methods are bound. That
covers ``Thread``, ``InputStream``, ``OutputStream``, ``Logger``,
``UndoableAction``, ``KeyListener``, ``DragAndDropTarget``, ``TreeViewItem``,
``MenuBarModel`` and the rest of the abstract classes.
``tools/inspect_juce.py`` therefore withholds ``make<Name>`` for an abstract
class and names the ``Custom<Name>`` to build instead. Emitting one produced a
binding that read as usable and was a compile error at every call site, which
nothing caught because nothing called it.
``tools/generate_subclasses.py`` writes that subclass for every abstract class
in a module, and is run the same way::

  for module in juce_core juce_events juce_data_structures juce_graphics juce_gui_basics; do
    PYTHONPATH=tools .venv/bin/python tools/generate_subclasses.py --module "$module" > "sources/june/${module}_subclasses.nim"
  done

A struct JUCE declares with no constructor of its own still has C++'s implicit
default one, and libclang reports no constructor at all. 21 aggregates were
declared with readable and writable fields and no way to build one --
``ZipFile::ZipEntry``, ``MouseWheelDetails``,
``DirectoryContentsList::FileInfo``, ``ThreadPool::Options`` among them. The
generator emits a default constructor for a non-abstract class that declares
none and has a public field.

libclang does not report that C++ *deleted* an implicit default because a
member has none either, which is the case for ``ColourLayer`` (it holds an
``EdgeTable``) and ``GlyphLayer`` (a variant over it). Only a call tells the
two apart, so those two are named in the generator with the reason, and
``check_handwritten_covered.py`` fails unless a test builds every one of the
constructors that is emitted.

Every bound JUCE enum is a ``distinct cint``, and Nim renders **one** closure
struct for ``proc(): cint`` and ``proc(): SomeEnum``, typing its function
pointer from whichever it emits first::

  typedef struct {
    N_NIMCALL_PTR(juce::ThreadPoolJob::JobStatus, ClP_0) (void* ClE_0);
    void* ClE_0;
  } tyProc__bZhuB40paOmpcx9bHElqj9aQ;   // also used for proc(): cint

A program holding both kinds then assigns a function pointer of the wrong type
and the C++ compiler rejects it. So no Nim closure names a distinct enum. A
subclass whose virtual returns one is marked ``basescalar`` by
``tools/generate_subclasses.py``: the callback takes and returns ``cint``, the
override keeps the enum to match the virtual, and the generated forwarder casts
the value. For a binding that takes such a ``std::function`` -- JUCE has one,
``ThreadPool.addJob`` -- ``bindEnumClosure`` does the same::

  let job: CppFunctionObjectR0[ThreadPoolJobJobStatus] =
    bindEnumClosure[ThreadPoolJobJobStatus](
      proc(): cint = cint(ThreadPoolJobJobStatus_jobHasFinished))

Both cast a value rather than a function pointer, which is defined. The suite
sets a ``cint`` handler and an enum one in the same program, which is what makes
the compiler check it.

A method returning ``const T*`` is bound as ``ConstPtr[T]``, not ``ptr T``. Nim
has no const pointer, and C++ does not convert ``const T*`` to ``T*``, so the
plain ``ptr`` spelling produced 31 procs that could not be called at all --
``ZipFile.getEntry``, ``ValueTree.getPropertyPointer``,
``Displays.getPrimaryDisplay``, ``ApplicationCommandManager.getCommandForID``
and the rest. ``ConstPtr`` has ``isNil`` and ``[]``, and ``[]`` yields the value
for reading::

  let info = manager.getCommandForID(commandID)
  if not info.isNil():
    echo info[].shortName()

Passing ``info[]`` to anything taking a ``var`` is a compile error, which is what
the C++ ``const`` means. A ``const T*`` *parameter* stays a plain ``ptr T``,
because that is the conversion C++ does make.

Both generators read the platform's headers, and JUCE hides some classes behind
``JUCE_MAC`` or ``JUCE_WINDOWS``, so the committed files are the macOS output
and CI checks them there. A ``generated files are current`` job regenerates and
diffs, which is what stops a generator change from landing without its output.

Hand-written bindings -- the ``*_lifting.nim`` files, ``june_juce_types``,
``june_stl``, ``june_common`` and ``june_function_utils`` -- get no such check
from the generator, and an ``importcpp`` string only reaches the C++ compiler
at the call site. A binding nothing calls is never compiled at all, which is
how a ``BorderSize`` constructor JUCE does not declare, four container types
with no constructor, and three ``Range`` setters that mutated a ``let`` binding
all sat in the tree. ``tools/check_handwritten_covered.py`` fails if an export
is never named by a test or an example::

  python3 tools/check_handwritten_covered.py

A binding a test genuinely cannot call -- one that builds the process's single
``JUCEApplication``, say -- goes in that script's ``uncallable`` table with the
reason, and the script fails if a listed name stops existing.

A class it cannot express is listed at the end of the file with the reason, in
the same style as an unbound proc. Count what is left with::

  grep -h '^#   ' sources/june/*_subclasses.nim

Each generated class exposes one setter per pure virtual, taking a plain Nim
closure::

  var stream = newCustomOutputStream()
  stream[].setWriteHandler(proc(data: pointer, bytes: csize_t): bool =
    written += bytes.int
    true)

JUCE calls the handler through the virtual, so ``stream.writeText(...)`` -
which is JUCE's own code - reaches it. The suite asserts that for this one and
for the other subclasses it drives, not for every setter. Setting a handler is
what type-checks and generates it, so a setter no test calls is unexercised;
the ones left are on classes the suite has no way to drive, such as
``CustomJUCEApplicationBase``. No figure is quoted here on purpose -- a count
in prose goes stale silently, and nothing reads this one.

The test suite constructs every generated subclass, which is the check that
matters, and ``check_handwritten_covered.py`` fails if one is not built. The
generated C++ has a template forwarding constructor, so a class whose base has
no default constructor compiles cleanly until something calls it, and a
subclass that leaves an inherited pure virtual unimplemented is still abstract
- neither shows up at build time.

That claim used to be prose, and it was false: 13 of the subclasses were never
built. Two were broken. ``CustomImagePixelData::clone`` was typed against
``DynamicObject::Ptr`` rather than ``ImagePixelData::Ptr``, because the
generator resolved a bare ``Ptr`` through a table keyed on the alias and JUCE
names dozens of things ``Ptr``. ``CustomComponentMovementWatcher`` overrode one
of three pure virtuals and was still abstract, because the walk that collects
them keyed on the method name, and ``ComponentListener`` declares a non-pure
``componentMovedOrResized`` with different parameters.

Building a subclass means using what the constructor returns. Discarding the
pointer does not compile the class: the C++ lives in a header the Nim type
carries, and Nim includes it only where the type itself is used.

``CustomJUCEApplicationBase`` and ``CustomThreadWithProgressWindow`` are named
in the checker with the reason a test cannot build them - the first trips
JUCE's single-application assertion, and the second is a top-level window that
segfaults on a headless Linux container.

The generator aborts on a parse error rather than emitting a binding for a type
it did not resolve. An unresolved type does not stop libclang, it degrades to
``int``, so a run that printed nothing and emitted a full file used to look
exactly like a correct one.

Edit the ``*_lifting.nim`` files, never the generated ``juce_*.nim`` files: a
regeneration overwrites them.
