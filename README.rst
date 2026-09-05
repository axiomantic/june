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
raised, so its exit code does not report a failure. That is true of every task
here -- ``test``, ``examples``, ``juce_debug`` -- not only of ``test``. Read the
output, or run the commands directly, which report properly:

.. code-block:: bash

  (for t in tests/test_juce_*.nim; do nim cpp -r "$t" || exit 1; done)
  (for e in examples/*.nim; do nim cpp "$e" || exit 1; done)

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

Do not capture a JUCE object in a closure. Convert it first: ``let name =
$someString`` captures a Nim string and is safe, and so is anything else Nim
owns.

A closure's environment is Nim's memory. Nim allocates it zeroed rather than
constructing it and never destroys what is in it, so a C++ object placed there
is neither constructed nor destructed. Both halves of that bite:

- Nothing releases what the object owns. Capturing an ``Image`` or a
  ``ValueTree`` leaks it, which JUCE's leak detector reports by name. A type
  whose ownership the detector does not track leaks just as surely and says
  nothing.
- ``String::operator=`` releases whatever the target held before, and from
  zeroed memory that is a null buffer it writes through. Capturing a
  ``String`` crashes outright, as does anything holding one: ``Identifier``
  and ``juce_var`` among them.

This is Nim's closure code generation rather than anything ``bindClosure``
does; a plain ``proc() = discard capturedString`` crashes the same way. A type
that owns nothing -- ``Colour``, ``Point``, ``Rectangle`` -- survives being
captured, but the rule is easier to hold than the exceptions.
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
  ``Component`` method. Only PUBLIC bases: a private one is not a subtype
  outside the class, and binding it as the parent offered every method it
  declares while C++ refused each call. What a class re-exports from a private
  base with a ``using`` declaration is bound on the class itself, which is how
  ``TimedCallback`` gets its five ``Timer`` methods.

  Nim carries ONE parent and C++ carries as many as it likes. The parent is the
  public base reaching the most, so ``TextEditor`` is a ``Component`` rather
  than the ``TextInputTarget`` it happens to list first. What the other public
  bases bring is written onto the class directly -- ``setTooltip`` on eight
  widgets, ``LookAndFeel``'s drawing hooks -- so the choice of parent does not
  decide what is reachable. A name arriving down two different base branches is
  left out, because calling it unqualified is ambiguous in C++ as well.

  Nested classes too, with their own methods and
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

  These seventeen are declared by hand in ``june_juce_types.nim``; the
  generator binds no class template of its own. JUCE declares 66 public ones,
  and the 49 that are left out cost nothing at the surface: no binding is
  withheld because of them. They are either JUCE's own machinery -- ``ArrayBase``,
  ``SingletonHolder``, ``LeakedObjectDetector`` -- or a container with a Nim
  equivalent, such as ``HashMap`` and ``SortedSet``. ``GenericScopedLock`` is
  the one whose absence shows: lock a ``CriticalSection`` with ``enter`` and
  ``exit`` in a ``try``/``finally``, which is the Nim shape of the same thing.
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

  A subclass is generated for a class with a pure virtual. A JUCE listener
  interface that gives every method an empty body instead -- ``ComponentListener``,
  ``MouseListener``, ``TextEditor::Listener``, ``ValueTree::Listener`` -- is not
  abstract, so no subclass is generated and there is nothing to override from
  Nim. The base itself is constructible, which is enough to register one, but
  its methods do nothing.

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
they are given to it. Each one carries ``==`` and ``$``, and the
flag sets -- the enums whose name ends in ``Flags``, which is how JUCE spells a
nested ``Flags`` enum -- also carry ``or`` and ``and``::

  let style = FontFontStyleFlags_bold or FontFontStyleFlags_italic
  if (style and FontFontStyleFlags_bold) == FontFontStyleFlags_bold: discard

``$`` prints the number rather than the name. The binding holds the C++
enumerator and there is no table of names on this side to look one up in.

An enum that binds a C++ SCOPED enum -- ``enum class`` -- also carries
``toCint``, and its ``$`` is written over that rather than borrowed. A scoped
enum does not convert to ``int`` on its own, so a borrowed ``$`` compiles here
and fails at the call site. 39 of the 129 bound enums are in that position.

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

----------------
What Is Tested
----------------

Two layers, because they answer different questions.

``tests/test_juce_compiles.nim`` is generated by
``tools/generate_compile_harness.py`` and CALLS every bound method once. It
asserts nothing. Its whole job is to reach the C++ compiler: an ``importcpp``
proc is a string until something calls it, so a binding that names a method
that does not exist, or gets an argument type wrong, compiles cleanly and fails
only for whoever calls it first. Regenerate it whenever the generator changes;
CI diffs it.

The five ``tests/test_juce_<module>.nim`` files assert BEHAVIOUR: what a method
returns, what it leaves alone, and which of two similar methods does which.
They cover the classes a program actually uses.

``tools/check_handwritten_covered.py`` is the gate between the two. It fails
when a hand-written binding, a generated subclass, a handler setter, a
constructor, a bound constant, a static variable or a field accessor is never
exercised. Every defect this branch fixed was found that way or by a test
written against it.

``tools/report_behavioural_coverage.py`` measures the second layer against the
first and prints a fixed-column table, so a later run can be diffed against an
earlier one::

  python3 tools/report_behavioural_coverage.py

One unit is one bound method on one class; overloads collapse into one, since a
test calling either exercises the name. The match is by name rather than by
receiver, which makes the uncalled figure a LOWER bound - it never claims
coverage that is not there.

The same tool lists what is left, so that the list is never a stale copy in a
document::

  python3 tools/report_behavioural_coverage.py --remaining

``docs/coverage-roadmap.rst`` describes the shape of that remainder and how to
choose the next class to cover.

What the behavioural layer does NOT reach, and why:

- Anything needing a real window server or real input. On Linux CI the suite
  runs under ``xvfb-run``; where a class still needs a physical device --
  ``MouseInputSource``, ``MouseEvent`` -- the compile harness is the only
  coverage.
- Anything that enters a modal loop. ``AlertWindow.showAsync`` and its
  relatives would block a test run, so they are called by the harness only.
- Anything delivered through the message QUEUE. ``TextEditor::textChanged``,
  ``Button::triggerClick`` and JUCE's other asynchronous callbacks post a
  message rather than calling back inline, and this suite cannot turn the
  queue: ``MessageManager::runDispatchLoopUntil`` sits behind
  ``JUCE_MODAL_LOOPS_PERMITTED``, which JUCE leaves off, so the generator never
  sees it. The tests assert that these calls do NOT fire inline, and invoke the
  stored ``std::function`` directly to show the Nim closure reached C++.
- On Linux, a real native window. Under ``xvfb-run`` a peer can be created, but
  X11 tears one down through the message queue rather than inside
  ``removeFromDesktop``, so the process exits holding it and the leak gate
  fails. ``AlertWindow`` and ``ComponentPeer`` are therefore covered
  behaviourally on macOS only, and each skip prints a line saying so.
- Platform-only methods. The harness marks these and calls them on macOS only;
  ``MACOS_ONLY_METHODS`` in the harness generator lists them.
- A handful of individual methods whose only effect is outside the process:
  ``File.addToDock`` rewrites the user's Dock preferences and restarts the
  Dock, ``Toolbar.showCustomisationDialog`` opens a modal dialog, and
  ``setCurrentDragImage`` dereferences a pointer that is null unless a drag is
  already under way. ``UNREACHABLE_METHODS`` in the report tool lists them one
  at a time, so the rest of each class still counts.
- The examples. They are built by CI, not run: each opens a window and waits
  for it to be closed, which never happens unattended.

JUCE's leak detector reports what is still alive at exit, and it PRINTS rather
than failing, so CI greps for it and fails the job. Two real defects were found
that way, both wrong beliefs about ownership rather than untidy tests.

A `jassert` behaves the same way: outside a debugger it writes one line to
stderr and the process carries on at exit code 0. So JUCE telling the suite
something is wrong reached the log and the job stayed green - which is how a
``MenuBarComponent`` outliving the model it was built over, a use-after-free
JUCE names in so many words, survived until a Linux run happened to segfault on
it. ``tools/check_juce_assertions.py`` reads the test output and fails on any
assertion site not listed as one the suite provokes on purpose::

  python3 tools/check_juce_assertions.py /tmp/test_logs/*.log

Each entry carries what JUCE asserts there and which test reaches it, and is
tagged with the platform that reaches it. Two are needed: gcc attributes a
multi-line assertion to its first line where clang attributes it to its last,
and some assertions live in per-platform files. A site listed for THIS platform
and no longer reached fails the check too, so an entry cannot outlive the test
that needed it.

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
in a module, nested ones included. It used to key a class on its own spelling,
which never matched a declared Nim name for a nested one, so 58 were skipped
with no withheld entry -- every ``Listener`` and ``LookAndFeelMethods``
interface an application implements, ``ComponentBuilder::TypeHandler``,
``TextEditor::InputFilter`` and the rest. A nested class carries a
``cppParent`` directive giving its real qualified spelling.

Four things a subclass cannot express are detected and withheld with the
reason: a virtual with more arguments than a ``std::function`` Nim can spell
(``importcpp`` substitutes a type by a single digit, so ten for a void
override and nine for one with a result), a handler returning a type with no
default constructor (Nim builds a temporary for a closure's result), a private
pure virtual, and an overloaded one. A fifth is a measured list: Nim hands some
objects to a C function by pointer and others by value, and which is which only
shows when the generated ``std::function`` is assigned -- ``Point<int>`` by
value works and ``Colour`` by value does not.

The forwarder falls back through ``june::fallback<R>()`` rather than
``return {}``, so a return type with no default constructor is a runtime
failure rather than a class that cannot be generated at all.

It is run the same way::

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

Two operators are marked ``{.error.}`` where JUCE gives nothing to build them
on, because Nim's fallback for each is a silent wrong answer. Comparing two
values of a class with no C++ ``operator==`` would use structural equality, and
an ``importcpp`` object declares no fields, so it would compare nothing and
call every two values equal. ``$`` on a class with no ``toString`` would print
``()`` for the same reason -- in exactly the place a person is trying to see
what a value is. 442 classes carry the equality guard and 480 the ``$`` one,
and the suite checks that both fire and that a class with a real
``operator==`` or ``toString`` is left alone.

A bound constant is not checked against C++ unless something reads it. A ``let``
naming ``juce::NoSuchClass::nope`` compiles clean while nothing touches it,
which was measured rather than assumed: when this was first checked, most of
the bound constants had never had their spelling put to the compiler. The suite
now reads every one and ``check_handwritten_covered.py`` fails if one is not
read, printing how many it checked. Every one of them was correct, which is
worth knowing rather than assuming.

A nested class is named by its parts joined together, and one of those
collided with a top-level class: ``juce::MessageManagerLock`` and
``juce::MessageManager::Lock`` both flattened to ``MessageManagerLock``. The
type was declared as the nested one while every method bound onto it came from
the top-level one, so the constructor could not be called and the methods were
attributed to a class that does not have them. The nested one is
``MessageManagerInnerLock`` now, and the generator carries the rename with that
reason.

``cnew`` takes a constructor call, not a name. Its ``importcpp`` pattern
expands to ``new T(args)``, so ``cnew(makeDrawableRectangle())`` works and
``cnew(existingValue)`` is rejected with "call expression expected for C++
pattern". Where the object needs configuring before it is handed over, build it
with ``cnew`` first and configure it through the pointer.

``Array[T]``'s ``[]`` returns by value, and Nim builds a temporary for that,
which needs ``T`` to be default-constructible. ``juce::TextLayout::Glyph`` is
not, so every element of a laid-out run was unreachable. ``getReference`` is
bound alongside it and hands back JUCE's own reference, needing nothing of
``T``.

A non-copyable container returned by value has to be used inline. ``OwnedArray``
is one, so ``line.runs().size()`` and ``line.runs()[i]`` are fine while
``var runs = line.runs()`` asks C++ for a copy it will not make -- and so does
``for run in line.runs()``, because the ``items`` iterator takes the array by
value.

A field whose type cannot be copy-assigned is set with ``std::move``. Nine
setters assigned one by copy and every call was rejected --
``PopupMenu::Item``'s ``subMenu`` and ``image``, ``FillType::gradient``,
``DialogWindowLaunchOptions::content`` and the accessibility interfaces. The
wrapper is empty afterwards, exactly as in C++, and the suite asserts that. The
move-only wrappers are named in ``tools/inspect_juce.py``: for these the copy
assignment is deleted implicitly, because of a member, and libclang does not
report that as a deleted method.

``Span``, ``WeakReference``, ``OptionalScopedPointer`` and ``Parallelogram``
had no constructor, and each is taken as a parameter by a binding, so those
bindings could not be called at all.

Three methods are withheld because JUCE declares them and defines them nowhere:
``RelativeCoordinate::references`` and ``createTree`` on ``RelativePointPath``'s
``QuadraticTo`` and ``CubicTo``. Nothing in the headers says so -- the binding
compiles, and the call fails at the link step -- so they are named in
``tools/inspect_juce.py`` with that reason, each one found by linking a call to
it.

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
all sat in the tree. ``tools/check_handwritten_covered.py`` is the guard
against that whole shape, and it fails when any of these is not exercised::

  python3 tools/check_handwritten_covered.py

- a hand-written binding name that no test calls
- a withheld ``begin()`` naming a Nim iterator that does not exist
- an emitted implicit default constructor that no test builds
- a generated subclass that no test builds
- a handler setter that no test calls
- a no-argument constructor that no test calls
- a bound constant or static variable that no test reads
- a class with a constructor that no test names
- a public field that no test reads or assigns
- an overload set taking a Nim ``int`` with no proc that accepts one losslessly
- the same signature declared more than once
- an inherited method a secondary base had to restate
- a macOS-only method called outside a ``when defined(macosx)`` guard
- a file under ``sources/`` whose copyright notice is missing, doubled, or -
  in a generated module - not byte-identical to the hand-written ones
- an exemption that covers more than one declaration, so its recorded reason
  excuses something it never named

It reports what it covered rather than only what failed, so the figures are
read off the run rather than out of this file.

Anything a test genuinely cannot reach goes in that script's tables with the
reason -- why a test *cannot*, never that nobody has yet -- and the script
fails the other way too, when a listed name stops existing.

A class it cannot express is listed at the end of the file with the reason, in
the same style as an unbound proc. Count what is left with::

  grep -h '^#   ' sources/june/*_subclasses.nim

Each generated class exposes one setter per pure virtual, taking a plain Nim
closure::

  var stream = newCustomOutputStream()
  stream[].setWriteHandler(proc(data: pointer, bytes: csize_t): bool =
    written += bytes.int
    true)

A nested interface is named by its parts joined together, so ``ComboBox::
Listener`` is ``CustomComboBoxListener`` and ``TextEditor::InputFilter`` is
``CustomTextEditorInputFilter``. They are used the same way, and this is how an
application listens to a widget from Nim::

  var listener = newCustomComboBoxListener()
  listener[].setComboBoxChangedHandler(proc(box: ptr ComboBox) =
    echo "now ", box[].getText())

  var box = makeComboBox(makeString("choices"))
  box.addListener(cast[ptr ComboBoxListener](listener))

JUCE calls the handler through the virtual, so ``stream.writeText(...)`` -
which is JUCE's own code - reaches it. The suite asserts that for this one and
for every setter it can. Setting a handler is what type-checks and generates
it, so a setter no test calls is never compiled at all, and
``check_handwritten_covered.py`` fails when one is not called. The only ones
left out are ``CustomJUCEApplicationBase``'s, named in that checker with the
reason: building one trips JUCE's assertion that the process has a single
application instance.

Calling them is what found ``CustomImagePixelData::clone`` typed against the
wrong class's ``Ptr``, and what showed that ``UniquePtr``,
``ReferenceCountedObjectPtr``, ``CppVector`` and ``CppString`` had no
constructor, so no override returning one could be written at all.

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
