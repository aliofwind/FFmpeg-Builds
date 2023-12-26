#!/bin/bash

SCRIPT_REPO="https://github.com/mpeg5/xeve.git"
SCRIPT_COMMIT="3890dae66c6b720dd3ffd53f31dbae80c48d7c5b"

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
    echo --enable-libxeve
}

ffbuild_unconfigure() {
    echo --disable-libxeve
}
