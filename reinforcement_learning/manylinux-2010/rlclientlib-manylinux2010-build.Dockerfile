FROM quay.io/pypa/manylinux2010_x86_64:latest

RUN yum install -y wget openssl-static ninja-build && yum clean all

RUN version=3.18 && build=2 \
   && wget -qO- "https://cmake.org/files/v$version/cmake-$version.$build-Linux-x86_64.tar.gz" \
   | tar --strip-components=1 -xz -C /usr/local

RUN wget -O zlib.tar.gz 'https://zlib.net/fossils/zlib-1.2.8.tar.gz' \
   && tar xvzf zlib.tar.gz \
   && cd zlib-1.2.8 \
   && ./configure --static --archs=-fPIC \
   && make -j$(nproc) \
   && make install \
   && cd .. && rm -rf zlib*

# Install FlatBuffers 1.12.0
RUN version=1.12.0 && \
 wget https://github.com/google/flatbuffers/archive/v$version.tar.gz \
 && tar -xzf v$version.tar.gz \
 && cd flatbuffers-$version \
 && mkdir build \
 && cd build \
 && cmake -G "Unix Makefiles" -DFLATBUFFERS_BUILD_TESTS=Off -DFLATBUFFERS_INSTALL=On -DCMAKE_BUILD_TYPE=Release -DFLATBUFFERS_BUILD_FLATHASH=Off .. \
 && make install -j$(nproc) \
 && cd ../../ \
 && rm -rf flatbuffers-$version \
 && rm v$version.tar.gz

COPY build-boost.sh build-boost.sh
RUN chmod +x build-boost.sh && ./build-boost.sh

# Checkout 2.10.18 version of cpprestsdk
RUN git clone https://github.com/Microsoft/cpprestsdk.git cpprestsdk \
   && cd cpprestsdk \
   && git checkout 122d09549201da5383321d870bed45ecb9e168c5 \
   && git submodule update --init --recursive \
   && cd Release \
   && mkdir build \
   && cd build \
   && cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DBoost_USE_STATIC_LIBS=On -DWERROR=OFF -DBUILD_TESTS=OFF -DBUILD_SAMPLES=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=On\
   && make -j `nproc` \
   && make install \
   && cd ../../../ \
   && rm -rf cpprestsdk