#!/bin/bash

SCRIPT_REPO="https://github.com/mpeg5/xevd.git"
SCRIPT_COMMIT="418ed6dfb5d09b9c730f0d474364436d994f4006"

ffbuild_enabled() {
    [[ $TARGET == win32 ]] && return -1
    return 0
}


ffbuild_dockerbuild() {
    cd "$FFBUILD_DLDIR/$SELF"

    mkdir build && cd build

    cmake ..
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libxevd
}

ffbuild_unconfigure() {
    echo --disable-libxevd
}
