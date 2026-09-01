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
  bound as Nim operators; ``!=``, ``>`` and ``>=`` follow from them.
- The class templates: ``Rectangle``, ``Point``, ``Line``, ``BorderSize``,
  ``Range``, ``Array``, ``OwnedArray``, ``Span``, ``RectangleList``,
  ``SparseSet`` and ``ReferenceCountedObjectPtr``.
- The standard library types JUCE exposes: ``std::unique_ptr``,
  ``std::optional``, ``std::vector`` and ``std::function``.

Instantiate a class template with ``cint`` or ``cfloat``, never Nim's ``int`` or
``float``. Nim puts the parameter's C++ name into the template, and Nim's
``int`` is 64-bit, so ``Rectangle[int]`` asks for a ``juce::Rectangle<long
long>`` that JUCE never instantiates.

A proc whose types cannot be spelled in Nim is emitted as a comment rather than
omitted, so what is missing stays visible in the generated file.

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


Or build the example application (tweak nim.cfg if needed).

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
      var windowName = application[].getApplicationName()

      application[].window = newDocumentWindow(windowName, makeColour(50'u8, 62'u8, 68'u8, 255'u8), DocumentWindow_allButtons, true)
      application[].window[].onCloseButtonPressed = bindClosure(proc() = JUCEApplication.getInstance().systemRequestedQuit())
      application[].window[].setResizable(true, true)
      application[].window[].centreWithSize(640, 480)
      application[].window[].setVisible(true)
    )

    application[].onShutdown = bindClosure(proc() =
      cdelete(application[].window)
      application[].window = nil
    )

    application[].onSystemRequestedQuit = bindClosure(proc() = application[].quit())

    result = application

  when isMainModule:
    START_JUCE_APPLICATION(createApplication)


Will look like this:

.. image:: https://github.com/kunitoki/june/blob/main/assets/example_app.png?raw=true
    :target: https://github.com/kunitoki/june/blob/main/examples/test_app.nim
