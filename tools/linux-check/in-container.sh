#!/usr/bin/env bash
# The Linux check, as it runs INSIDE the container. Not meant to be invoked
# directly; tools/linux-check/run.sh sets up the mounts and calls this.
#
# It reproduces the Linux half of the "Build JUCE" and "Run tests" steps of
# .github/workflows/ci.yml. Where it differs from CI, it says so at the point
# of difference, and run.sh's --help lists every difference in one place.
set -uo pipefail

# Not `set -e`. Every failure below is checked and reported explicitly, because
# a step that fails silently and a step that never ran look the same from the
# outside, and `-e` gives no chance to print WHICH artefact was missing.

run_step() {
    echo
    echo "=== $* ==="
}

fail() {
    echo
    echo "LINUX CHECK FAILED: $*" >&2
    exit 1
}

tests=("$@")
[ ${#tests[@]} -gt 0 ] || fail "no test files were given"

cd /work || fail "the repository is not mounted at /work"

run_step "nim --version"
nim --version | sed -n '1p' || fail "no working Nim compiler on PATH"

# ---------------------------------------------------------------------------
# JUCE.
#
# nimble is not used for this. CI calls `nimble juce_debug`, whose body is the
# two cmake commands below plus -DCMAKE_OSX_DEPLOYMENT_TARGET, which is inert
# on Linux. Calling cmake directly avoids needing nimble in the image at all,
# and nimble 0.22 exits 0 whatever happens, so its exit code was never what CI
# trusted either - CI checks for the library file, and so does this.
#
# /work/build is a Docker volume, not part of the bind-mounted tree. The host's
# own build directory holds a macOS library of the same name at the same path
# and must not be overwritten.
# ---------------------------------------------------------------------------
library=build/june_artefacts/Debug/libjune.a

if [ -f "$library" ] && [ "${JUNE_LINUX_CHECK_REBUILD_JUCE:-0}" != 1 ]; then
    echo
    echo "=== JUCE: reusing $library ($(stat -c %s "$library") bytes) ==="
else
    run_step "Build JUCE (this is the slow one; it is cached in a volume)"
    cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug \
        || fail "cmake configure failed"
    cmake --build build || fail "cmake build failed"
fi

# The artefact, not the exit status. A cmake that no-ops over a broken cache
# still exits 0.
[ -f "$library" ] || fail "$library was not produced"
ls -l "$library"

# ---------------------------------------------------------------------------
# The suite.
#
# --outdir and --nimcache point outside the bind mount so nothing is written
# into the host's working tree. CI has no such constraint and writes both into
# the checkout; the compilation is otherwise the same command.
#
# xvfb-run is what CI does on Linux and is the reason this check exists in a
# form that can run window code at all: without an X server an AlertWindow's
# constructor reaches juce_XWindowSystem_linux.cpp and SEGFAULTS, so the
# failure would not even be a test failure.
# ---------------------------------------------------------------------------
command -v xvfb-run > /dev/null \
    || fail "xvfb-run is not installed, so the suite would run headless without saying so"

logs=/tmp/test_logs
rm -rf "$logs" && mkdir -p "$logs"

leaked=0
for test_file in "${tests[@]}"; do
    [ -f "$test_file" ] || fail "no such test file: $test_file"
    name=$(basename "$test_file" .nim)
    run_step "$test_file"
    output=/tmp/test_output
    # Redirected rather than piped, for the reason CI gives: a pipe would hand
    # this the exit status of the last command in it.
    xvfb-run -a --server-args="-screen 0 1920x1080x24" \
        nim cpp -r --hints:off \
            --nimcache:"/nimcache/$name" \
            --outdir:/out \
            "$test_file" > "$output" 2>&1
    status=$?
    cat "$output"
    cp "$output" "$logs/$(basename "$test_file").log"
    [ $status -eq 0 ] || fail "$test_file exited $status (compile failure or failing test)"

    # JUCE's leak detector PRINTS and lets the process exit 0.
    if grep -q "Leaked objects detected" "$output"; then
        echo "$test_file leaked:" >&2
        grep "Leaked objects detected" "$output" >&2
        leaked=1
    fi
done

[ "$leaked" = 0 ] || fail "JUCE reported leaked objects"

# ---------------------------------------------------------------------------
# Assertions. A jassert PRINTS and carries on, exactly as the leak detector
# does.
#
# The checker makes three checks in order, returning at the first that fails:
# every announcement's site was parsed, no site fired that is not listed for
# this platform, and no listed site went unreached. The third one - staleness -
# is a statement about the WHOLE suite, so on a subset run it reports sites that
# only the omitted tests reach. Because the checker returns at the first
# failure, seeing the stale report as the first line of its output is proof
# that the other two checks passed, which is what lets a subset run treat it as
# a note rather than a failure. A full run applies all three, as CI does.
# ---------------------------------------------------------------------------
run_step "JUCE assertions"
assertion_output=$(python3 tools/check_juce_assertions.py --platform=linux "$logs"/*.log 2>&1)
assertion_status=$?
echo "$assertion_output"

if [ $assertion_status -ne 0 ]; then
    if [ "${JUNE_LINUX_CHECK_FULL_SUITE:-0}" = 1 ]; then
        fail "check_juce_assertions.py exited $assertion_status"
    elif [ "$(printf '%s\n' "$assertion_output" | sed -n '1p')" \
           = "These sites are listed as deliberately provoked on linux and no run reaches them any more, so the reason they carry is no longer checked against anything:" ]; then
        echo
        echo "NOTE: the staleness half of the assertion check needs the whole"
        echo "suite and this was a subset, so the sites above are unreached"
        echo "rather than stale. The other two halves of the check passed."
    else
        fail "check_juce_assertions.py exited $assertion_status"
    fi
fi

# ---------------------------------------------------------------------------
# Examples. Built, never run: they open a window and wait to be closed. CI
# builds them because the README reproduces them.
# ---------------------------------------------------------------------------
if [ "${JUNE_LINUX_CHECK_EXAMPLES:-0}" = 1 ]; then
    for example in examples/*.nim; do
        run_step "$example"
        # Not -c: that stops after emitting C++ and never invokes the C++
        # compiler, so an example generating invalid C++ would pass.
        nim cpp --hints:off \
            --nimcache:"/nimcache/example_$(basename "$example" .nim)" \
            --outdir:/out \
            "$example" || fail "$example did not build"
    done
fi

echo
echo "LINUX CHECK PASSED"
