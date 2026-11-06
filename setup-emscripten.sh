set -e
# install emscripten
git clone https://github.com/emscripten-core/emsdk.git
pushd emsdk
./emsdk install latest
./emsdk activate latest
. /emsdk/emsdk_env.sh
popd

pushd /tmp
# boost 
pushd boost
./bootstrap.sh
./b2 --prefix=/usr/emscripten -j4 --without-python toolset=emscripten stage
mkdir -p /usr/emscripten/lib /usr/emscripten/include
cp -r stage/lib /usr/emscripten
cp -r boost /usr/emscripten/include
popd

# soci
pushd soci
emcmake cmake . -DCMAKE_INSTALL_PREFIX=/usr/emscripten -DSOCI_CXX11=on -DSOCI_TESTS=off
make -j4 install
popd

# libsodium
git clone --branch=stable https://github.com/jedisct1/libsodium.git
pushd libsodium
emconfigure ./configure --enable-minimal --disable-shared --prefix=/usr/emscripten
emmake make -j4
emmake make install
popd

# emsdk directory needs to be writeable by everybody
chmod -R a+w /emsdk

popd
