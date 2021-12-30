FROM quay.io/pypa/manylinux2014_aarch64:latest

RUN yum install -y wget && yum clean all

RUN version=3.19 && build=3 \
   && wget -qO- "https://cmake.org/files/v$version/cmake-$version.$build-Linux-aarch64.tar.gz" \
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
COPY python-config.jam python-config.jam
RUN chmod +x build-boost.sh && ./build-boost.sh
