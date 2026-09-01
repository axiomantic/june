# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.

# Reproduced in the README. CI compiles every example, so the documentation
# cannot drift away from the API without something going red.

import june

proc main() =
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

  cdelete component

main()
