#!/bin/bash

SCRIPT_REPO="https://github.com/saindriches/davs2.git"
SCRIPT_COMMIT="ab855926d4fdc8b3acb33aafe3d3f47d93f32a58"

ffbuild_enabled() {
    [[ $VARIANT == lgpl* ]] && return -1
    [[ $TARGET == win32 ]] && return -1
    # davs2 aarch64 support is broken
    # [[ $TARGET == *arm64 ]] && return -1
    return 0
}

ffbuild_dockerdl() {
    default_dl .
    echo "git fetch --unshallow"
}

ffbuild_dockerbuild() {
    git clone "$SCRIPT_REPO" davs2
    cd davs2
    git checkout "$SCRIPT_COMMIT"
    cd build/linux

    local myconf=(
        --disable-cli
        --enable-pic
        --bit-depth=10
        --prefix="$FFBUILD_PREFIX"
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
    make install DESTDIR="$FFBUILD_DESTDIR"
}

ffbuild_configure() {
    echo --enable-libdavs2
}

ffbuild_unconfigure() {
    echo --disable-libdavs2
}
