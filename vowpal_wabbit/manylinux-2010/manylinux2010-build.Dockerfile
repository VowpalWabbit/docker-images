FROM quay.io/pypa/manylinux2010_x86_64:latest

RUN yum install -y wget && yum clean all

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

COPY build-boost.sh build-boost.sh
COPY python-config.jam python-config.jam
RUN chmod +x build-boost.sh && ./build-boost.sh
