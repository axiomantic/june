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

- Nim 1.6 or newer.
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

      application[].onInitialise = bindClosure(proc(commandLine: String) =
          echo "Starting JUNE App " & $commandLine

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
rather than assigning ``onPaint`` or ``onMouseDown``: Nim emits the importcpp
pattern unsubstituted when a ``bindClosure`` call is assigned straight to one of
those fields. The setters do the binding through a typed temporary, which does
not hit it.

The no-argument overrides -- ``onResized``, ``onMoved``, ``onVisibilityChanged``,
``onParentHierarchyChanged``, ``onChildrenChanged`` -- are assigned directly with
``bindClosure``.

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
  ``Component`` method.
- Constructors, as ``make<ClassName>`` procs.
- Enums, as distinct integer types. Enumerators are prefixed with the type name:
  ``JustificationFlags_centred``, ``NotificationType_sendNotification``.
- Operators. ``==``, ``<``, ``<=``, ``+``, ``-``, ``*``, ``/`` and ``[]`` are
  bound as Nim operators; ``!=``, ``>`` and ``>=`` follow from them. Compound
  assignment -- ``+=``, ``-=``, ``*=``, ``/=``, ``|=``, ``&=``, ``^=``, ``%=``,
  ``<<=`` and ``>>=`` -- is bound as a statement returning nothing, where C++
  returns a reference to the target.
- The class templates: ``Rectangle``, ``Point``, ``Line``, ``BorderSize``,
  ``Range``, ``Array``, ``OwnedArray``, ``Span``, ``RectangleList``,
  ``SparseSet``, ``NormalisableRange``, ``Parallelogram``, ``Optional`` and
  ``ReferenceCountedObjectPtr``.
- Iterators over the containers a caller loops over: ``ValueTree`` children and
  properties, ``StringArray``, ``XmlElement`` children, ``NamedValueSet``,
  ``Array``, ``OwnedArray``, ``Span``, ``RectangleList`` and ``std::vector``.
  JUCE's ``begin`` and ``end`` have no Nim spelling, so these are written over
  the indexed accessors instead.
- The standard library types JUCE exposes: ``std::unique_ptr``,
  ``std::optional``, ``std::vector``, ``std::string`` and ``std::function``.
- Subclasses whose virtual methods call into Nim: ``CustomComponent``,
  ``CustomButton``, ``CustomTimer``, ``CustomAsyncUpdater``,
  ``CustomActionListener``, ``CustomChangeListener``, ``CustomSlider``,
  ``CustomLabel`` and ``CustomLookAndFeel``, plus the ``JUCEApplication`` and
  ``DocumentWindow`` that were already there. Most of those JUCE classes have a pure virtual, so they
  could not be instantiated without a subclass at all.

Instantiate a class template with ``cint`` or ``cfloat``, never Nim's ``int`` or
``float``. Nim puts the parameter's C++ name into the template, and Nim's
``int`` is 64-bit, so ``Rectangle[int]`` asks for a ``juce::Rectangle<long
long>`` that JUCE never instantiates.

A proc whose types cannot be spelled in Nim is emitted as a comment rather than
omitted, so what is missing stays visible in the generated file.

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

  python3 -m pip install --user libclang

  for module in juce_core juce_events juce_data_structures juce_graphics juce_gui_basics; do
    PYTHONPATH=tools python3 tools/inspect_juce.py --module "$module" > "sources/june/$module.nim"
  done

The generator aborts on a parse error rather than emitting a binding for a type
it did not resolve. An unresolved type does not stop libclang, it degrades to
``int``, so a run that printed nothing and emitted a full file used to look
exactly like a correct one.

Edit the ``*_lifting.nim`` files, never the generated ``juce_*.nim`` files: a
regeneration overwrites them.
