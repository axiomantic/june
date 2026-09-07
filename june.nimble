# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

version       = "0.0.1"
author        = "kunitoki"
description   = "Juce Bindings For Nim"
license       = "MIT"
srcDir        = "sources"

requires "nim >= 2.2.2"

task test, "Runs the test suite":
  exec "nim cpp -r tests/test_juce_core.nim"
  exec "nim cpp -r tests/test_juce_events.nim"
  exec "nim cpp -r tests/test_juce_data_structures.nim"
  exec "nim cpp -r tests/test_juce_graphics.nim"
  exec "nim cpp -r tests/test_juce_gui_basics.nim"

task examples, "Build every example":
  # Built but not run: they open a window. CI runs the same check, because the
  # examples are reproduced in the README.
  #
  # Not -c. That stops after emitting C++ and never invokes the C++ compiler,
  # so an example that generates invalid C++ would pass.
  exec "nim cpp examples/custom_component.nim"
  exec "nim cpp examples/rotary_panel.nim"
  exec "nim cpp examples/test_app.nim"

task juce_debug, "Build juce (debug)":
  exec "cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_OSX_DEPLOYMENT_TARGET=11.6 && cmake --build build"

task juce_release, "Build juce (release)":
  exec "cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_DEPLOYMENT_TARGET=11.6 && cmake --build build"

task app_debug, "Compile and run june app (debug)":
  exec "nim cpp examples/test_app.nim"
  when defined(macosx):
    exec "mkdir -p examples/test_app.app/Contents/{MacOS,Resources,Frameworks}"
    exec "cp Info.plist examples/test_app.app/Contents"
    exec "sed -e 's/APP_NAME/test_app/g' -i '' examples/test_app.app/Contents/Info.plist"
    exec "mv examples/test_app examples/test_app.app/Contents/MacOS"
    exec "chmod +x examples/test_app.app/Contents/MacOS/*"
    exec "examples/test_app.app/Contents/MacOS/test_app"

task app_release, "Compile and run june app (release)":
  exec "nim cpp -d:release examples/test_app.nim"
  when defined(macosx):
    exec "mkdir -p examples/test_app.app/Contents/{MacOS,Resources,Frameworks}"
    exec "cp Info.plist examples/test_app.app/Contents"
    exec "sed -e 's/APP_NAME/test_app/g' -i '' examples/test_app.app/Contents/Info.plist"
    exec "mv examples/test_app examples/test_app.app/Contents/MacOS"
    exec "chmod +x examples/test_app.app/Contents/MacOS/*"
    exec "examples/test_app.app/Contents/MacOS/test_app"
