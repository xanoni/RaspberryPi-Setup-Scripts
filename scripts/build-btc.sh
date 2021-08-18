#! /usr/bin/env -S bash -ex

## Compile Bitcoin Core on ARM32 (e.g., RaspberryPi 4B) — no GUI
## See also: https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md

BTC_REV="v22.0rc2"
MAKE_JARG=3
BTC_PREFIX="$HOME/buidl/bitcoin.git"
BDB_PREFIX="${BTC_PREFIX}/db4"

cd "${BTC_PREFIX}"

## update repo && check out rev
git fetch -v origin && git checkout "${BTC_REV}"

## apt preparation
sudo apt remove --autoremove libdb-dev libdb++-dev
sudo apt update && sudo apt upgrade

## install deps
sudo apt install \
    make automake cmake curl libtool binutils-gold bsdmainutils pkg-config \
    python3 patch bison g++-arm-linux-gnueabihf curl libsqlite3-dev \
    build-essential autotools-dev libevent-dev libboost-dev \
    libboost-system-dev libboost-filesystem-dev libboost-test-dev

## install BDB
./contrib/install_db4.sh "$(pwd)"

## make ARM ready
(cd ./depends && make HOST=arm-linux-gnueabihf NO_QT=1)

## autogen
./autogen.sh

## configure
CONFIG_SITE=$PWD/depends/arm-linux-gnueabihf/share/config.site ./configure \
    BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" \
    BDB_CFLAGS="-I${BDB_PREFIX}/include" --enable-glibc-back-compat \
    --enable-reduce-exports --without-gui --enable-hardening \
    --without-miniupnpc --without-natpmp LDFLAGS=-static-libstdc++

## make && make install
make -j "${MAKE_JARG}"
sudo make install

## restart service
sudo systemctl restart bitcoind

