#!/usr/bin/env bash
# Run the test suite on Linux, from a macOS workstation, before pushing.
#
#   tools/linux-check/run.sh                       # the whole suite
#   tools/linux-check/run.sh tests/test_juce_graphics.nim
#   tools/linux-check/run.sh --examples            # suite + build the examples
#   tools/linux-check/run.sh --rebuild-image       # after editing the Dockerfile
#   tools/linux-check/run.sh --rebuild-juce        # after a JUCE submodule bump
#   tools/linux-check/run.sh --help
#
# =============================================================================
# WHAT THIS PROVES, AND WHAT IT DOES NOT
# =============================================================================
#
# It exists because two defects in one month passed on macOS and failed only on
# Ubuntu CI. Verifying on macOS alone cannot catch that class by construction:
# the platform difference IS the defect. This runs the same suite against the
# same Linux headers, the same X11 and FreeType libraries, and the same virtual
# X server that CI uses.
#
# It PROVES, for the working tree as it is on disk right now:
#
#   - the bindings compile against Linux JUCE, with Linux's per-platform
#     `#if JUCE_LINUX` code paths taken;
#   - the tests pass with a real X server present, so the classes that need a
#     desktop peer are actually exercised rather than segfaulting;
#   - JUCE's leak detector reported nothing (it PRINTS and exits 0, so it must
#     be grepped for or a leak reaches the log under a green run);
#   - JUCE asserted only where tools/check_juce_assertions.py lists it as
#     deliberately provoked on Linux (a jassert also PRINTS and exits 0).
#
# It does NOT prove:
#
#   - ARCHITECTURE. This builds for the host's native architecture. On an Apple
#     Silicon Mac that is linux/arm64; CI's ubuntu-latest is x86_64. Anything
#     rooted in word size, endianness, floating-point contraction, SIMD, or a
#     `#if defined(__x86_64__)` in JUCE is out of reach, and so is any Linux
#     defect whose Ubuntu package differs by architecture. What IS reached is
#     the much larger class of Linux-versus-macOS differences: different system
#     headers, X11 instead of Cocoa, FreeType and fontconfig instead of
#     CoreText, and glibc instead of libSystem. The two defects this check was
#     built for are both in that class. To close the gap, add
#     `--platform=linux/amd64` to the docker commands below - it works, under
#     emulation, and the JUCE build then takes a great deal longer.
#
#   - THE RUNNER'S EXACT ENVIRONMENT. This image is a bare ubuntu:24.04 plus
#     the packages CI installs and the toolchain the runner already carries.
#     GitHub's runner image carries a great deal more. Two known consequences:
#     the FONT SET differs (the Dockerfile installs DejaVu and Liberation
#     because the graphics suite asks the host for the default family's styles
#     and a fontless machine has none - the runner's set is larger, so a text
#     metric could differ between the two), and JUCE's cmake finds no GL, GTK
#     or WebKit here where the runner may. Neither module is linked, so the
#     second is inert today; a CMakeLists change that starts linking one would
#     make this image diverge silently.
#
#   - NIM 2.2.2. CI's matrix runs 2.2.2 and 2.2.10 on Linux; this image pins
#     2.2.10, so a defect only the older compiler shows still needs CI.
#
#   - THE GENERATED-FILES JOB. CI's `generated` job regenerates the bindings
#     with libclang and diffs them, and runs the coverage checks. That job is
#     macOS-only by design and this check does not touch it.
#
#   - macOS. It is not a replacement for running the suite locally; it is the
#     other half of it.
#
#   - THE EXAMPLES, unless --examples is passed. CI always builds them.
#
# =============================================================================
# HOW IT IS ARRANGED
# =============================================================================
#
# The repository is bind-mounted READ-ONLY at /work, never copied into the
# image, so a code change needs no rebuild and a run cannot write into the
# working tree. Three named volumes carry everything a run would otherwise
# recompute or otherwise write:
#
#   june-linux-check-build     mounted over /work/build - the JUCE static
#                              library. This is the expensive artefact and the
#                              reason for the volume: it is built once and
#                              reused by every later run. Mounting it OVER the
#                              bind mount also keeps the host's own macOS build
#                              directory untouched.
#   june-linux-check-nimcache  Nim's cache, which is what makes a warm run of
#                              an unchanged test fast.
#   june-linux-check-out       the compiled test binaries, kept out of the
#                              tree for the same reason as the build directory:
#                              a Linux binary written beside a macOS one of the
#                              same name would silently replace it.
#
# Nothing here deletes a volume. To discard them:
#
#   docker volume rm june-linux-check-build june-linux-check-nimcache \
#       june-linux-check-out
#
set -uo pipefail

image=june-linux-check
build_volume=june-linux-check-build
nimcache_volume=june-linux-check-nimcache
out_volume=june-linux-check-out

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)

die() { echo "$*" >&2; exit 1; }

rebuild_image=0
rebuild_juce=0
examples=0
tests=()

while [ $# -gt 0 ]; do
    case "$1" in
        --help|-h) sed -n '2,/^set -uo/p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
        --rebuild-image) rebuild_image=1 ;;
        --rebuild-juce) rebuild_juce=1 ;;
        --examples) examples=1 ;;
        -*) die "unknown option: $1 (try --help)" ;;
        *) tests+=("$1") ;;
    esac
    shift
done

full_suite=0
if [ ${#tests[@]} -eq 0 ]; then
    full_suite=1
    # The same glob CI iterates, expanded on the host so an empty match is
    # caught here rather than reaching the container as a literal.
    shopt -s nullglob
    tests=("$repo"/tests/test_juce_*.nim)
    shopt -u nullglob
    [ ${#tests[@]} -gt 0 ] || die "tests/test_juce_*.nim matched nothing in $repo"
    # Paths relative to the repository root, which is where they are mounted.
    tests=("${tests[@]#"$repo"/}")
fi

command -v docker > /dev/null || die "docker is not on PATH"
docker info > /dev/null 2>&1 || die "the Docker engine is not running"

[ -f "$repo/tools/check_juce_assertions.py" ] \
    || die "$repo does not look like the june repository"
[ -e "$repo/JUCE/CMakeLists.txt" ] \
    || die "the JUCE submodule is not checked out; run: git submodule update --init --recursive"

start=$SECONDS

if [ "$rebuild_image" = 1 ] || ! docker image inspect "$image" > /dev/null 2>&1; then
    echo "=== building the $image image ==="
    docker build -t "$image" "$repo/tools/linux-check" \
        || die "the image did not build"
fi

# `docker volume create` is idempotent, and creating them here rather than
# letting `docker run` do it keeps the names in one place.
for volume in "$build_volume" "$nimcache_volume" "$out_volume"; do
    docker volume create "$volume" > /dev/null || die "could not create volume $volume"
done

docker run --rm \
    --mount "type=bind,source=$repo,target=/work,readonly" \
    --mount "type=volume,source=$build_volume,target=/work/build" \
    --mount "type=volume,source=$nimcache_volume,target=/nimcache" \
    --mount "type=volume,source=$out_volume,target=/out" \
    -e "JUNE_LINUX_CHECK_REBUILD_JUCE=$rebuild_juce" \
    -e "JUNE_LINUX_CHECK_EXAMPLES=$examples" \
    -e "JUNE_LINUX_CHECK_FULL_SUITE=$full_suite" \
    "$image" \
    bash /work/tools/linux-check/in-container.sh "${tests[@]}"
status=$?

echo
echo "elapsed: $((SECONDS - start))s"
exit $status
