#!/bin/bash

SCRIPT_REPO="https://github.com/mpeg5/xevd.git"
SCRIPT_COMMIT="4e76654c5f2595d8e24d7577ebe9b92cdfdb442f"

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
