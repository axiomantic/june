# The Linux side of the test suite, runnable from a macOS workstation.
#
# The repository is NOT copied in. It is bind-mounted at run time by
# tools/linux-check/run.sh, so an edit on the host is visible to the next run
# with no rebuild. What the image holds is only what a code change cannot
# invalidate: the apt packages, and the Nim compiler.
#
# The expensive artefact - the JUCE static library - is not in the image
# either. It lives in a named Docker volume mounted over /work/build, so it is
# built once and reused, and it never touches the host's own build directory.
#
# The package list is the one CI installs in the "Install Linux dependencies"
# step of .github/workflows/ci.yml, plus the toolchain GitHub's runner image
# already carries (build-essential, cmake, git, python3). Keep the two lists in
# step: a package here that CI lacks makes this check pass over a break that CI
# would report.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
        ninja-build \
        pkg-config \
        libfreetype-dev \
        libfontconfig1-dev \
        libx11-dev \
        libxext-dev \
        libxinerama-dev \
        libxrandr-dev \
        libxcursor-dev \
        libxcomposite-dev \
        libcurl4-openssl-dev \
        xvfb \
        build-essential \
        cmake \
        git \
        python3 \
        ca-certificates \
        curl \
        xz-utils \
        fontconfig \
        fonts-dejavu-core \
        fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# The three font packages and fontconfig are NOT in CI's apt list, and they are
# not decoration. GitHub's ubuntu-24.04 runner image ships fonts already, so CI
# never had to ask for them; a bare ubuntu:24.04 has none at all, and
# `fc-list` returns nothing. The graphics suite asks JUCE for the styles of the
# default family and asserts the current one is among them - on a machine with
# no fonts that list is empty and the suite fails for a reason that says
# nothing about the code. Which fonts these are is not matched to the runner's
# set; see the limitations in run.sh.
#
# The check is the artefact, not the install: a font package that stopped being
# pulled in would otherwise reappear as a mysterious graphics failure.
RUN test "$(fc-list | wc -l)" -gt 0 || { echo "no fonts are installed" >&2; exit 1; }

# CI's matrix tests 2.2.2 and 2.2.10. This image pins 2.2.10 - the upper bound,
# and the only one macOS CI also runs - so a failure here is a platform
# difference rather than a compiler-version difference. A defect that only
# 2.2.2 shows is out of this check's reach; see the README section in run.sh.
ARG NIM_VERSION=2.2.10

# nim-lang.org publishes prebuilt linux_x64 and linux_arm64 archives. CI reaches
# the compiler through nimble instead, because its matrix has to select a
# version and nimble is what resolves the package's own `requires "nim ..."`.
# Neither route changes the compiler that ends up on PATH, and the `--version`
# check below is what proves which one did.
RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
        arm64) nim_arch=linux_arm64 ;; \
        amd64) nim_arch=linux_x64 ;; \
        *) echo "no published Nim build for $(dpkg --print-architecture)" >&2; exit 1 ;; \
    esac; \
    curl -fsSL -o /tmp/nim.tar.xz \
        "https://nim-lang.org/download/nim-${NIM_VERSION}-${nim_arch}.tar.xz"; \
    mkdir -p /opt/nim; \
    tar -xJf /tmp/nim.tar.xz -C /opt/nim --strip-components=1; \
    rm /tmp/nim.tar.xz; \
    # An extracted archive is not yet a working compiler, and a wrong version
    # extracted cleanly looks identical to the right one. Assert the version
    # here, at build time, so the image cannot exist carrying the wrong Nim.
    /opt/nim/bin/nim --version | head -n 1 | grep -F "Version ${NIM_VERSION} "

ENV PATH=/opt/nim/bin:$PATH

# The repository arrives here as a read-only bind mount. Nim's output and cache
# are directed outside it so that a run cannot write into the host's working
# tree - another session may hold uncommitted work there, and a Linux binary
# dropped beside a macOS one of the same name would silently replace it.
WORKDIR /work
