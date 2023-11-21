#!/bin/bash

SCRIPT_REPO="https://github.com/mpeg5/xeve.git"
SCRIPT_COMMIT="cebfd5c0350ebcab0e08840af3a35b5a2773563b"

ffbuild_enabled() {
    [[ $TARGET == win32 ]] && return -1
    return 0
}


ffbuild_dockerbuild() {
    cd "$FFBUILD_DLDIR/$SELF"

    mkdir build && cd build

    cmake .. -G "MinGW Makefiles"
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libxeve
}

ffbuild_unconfigure() {
    echo --disable-libxeve
}
