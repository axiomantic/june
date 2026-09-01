# June - Copyright (c) 2022 Lucio Asnaghi, Gavin Ray
#
# Licensed and distributed under the
#   MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#
# This file may not be copied, modified, or distributed except according to those terms.


# Rectangle-taking overloads ==================================================
#
# The generator emits these commented out, because it cannot spell a template.

# Not a {.constructor.}: that pragma makes Nim ignore the importcpp pattern and
# emit Image(args) verbatim, losing the cast the PixelFormat parameter needs.


# Constructors are not generated at all, so the ones the tests and examples need
# are declared here.
