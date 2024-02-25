#!/bin/bash

SCRIPT_REPO="https://github.com/aliofwind/davs2-10bit"
SCRIPT_COMMIT="21d64c8f8e36af71fc7a488cd6f789c86cdd1200"

ffbuild_enabled() {
    [[ $VARIANT == lgpl* ]] && return -1
    [[ $TARGET == win32 ]] && return -1
    # davs2 aarch64 support is broken
    [[ $TARGET == linuxarm64 ]] && return -1
    return 0
}

ffbuild_dockerdl() {
    default_dl .
    echo "git fetch --unshallow"
}

ffbuild_dockerbuild() {
    cd build/linux

    local myconf=(
        --disable-cli
        --enable-pic
        --prefix="$FFBUILD_PREFIX"
        --bit-depth=10
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
            --cross-prefix="$FFBUILD_CROSS_PREFIX"
        )
    else
        echo "Unknown target"
        return -1
    fi

    # Work around configure endian check failing on modern gcc/binutils.
    # Assumes all supported archs are little endian.
    sed -i -e 's/EGIB/bss/g' -e 's/naidnePF/bss/g' configure

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-libdavs2
}

ffbuild_unconfigure() {
    echo --disable-libdavs2
}
