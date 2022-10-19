FROM quay.io/pypa/manylinux2014_x86_64:latest

RUN yum install -y wget && yum clean all

RUN version=3.19 && build=3 \
   && wget -qO- "https://cmake.org/files/v$version/cmake-$version.$build-Linux-x86_64.tar.gz" \
   | tar --strip-components=1 -xz -C /usr/local

RUN wget -O zlib.tar.gz 'https://zlib.net/fossils/zlib-1.2.8.tar.gz' \
   && tar xvzf zlib.tar.gz \
   && cd zlib-1.2.8 \
   && ./configure --static --archs=-fPIC \
   && make -j$(nproc) \
   && make install \
   && cd .. && rm -rf zlib*

RUN BOOST_MAJOR=1 && BOOST_MINOR=76 && BOOST_PATCH=0 && \
   wget --no-check-certificate -O /tmp/boost.tar.gz "https://sourceforge.net/projects/boost/files/boost/${BOOST_MAJOR}.${BOOST_MINOR}.${BOOST_PATCH}/boost_${BOOST_MAJOR}_${BOOST_MINOR}_${BOOST_PATCH}.tar.gz/download" && \
   mkdir /tmp/boost_src/ && \
   tar -xzf /tmp/boost.tar.gz -C /tmp/boost_src/ && \
   # This helps find then nested folder irrespective of verison.
   BOOST_ROOT="$( find /tmp/boost_src/* -maxdepth 0 -type d -name 'boost*' )" && \
   cd $BOOST_ROOT && \
   ./bootstrap.sh --with-libraries=math && \
   ./b2 -j$(nproc) cxxflags="-fPIC" variant=release link=static install && \
   cd / && \
   rm -rf /tmp/boost_src/ /tmp/boost.tar.gz

RUN wget --no-check-certificate https://github.com/fmtlib/fmt/releases/download/9.1.0/fmt-9.1.0.zip && \
   unzip fmt-9.1.0.zip && \
   cd fmt-9.1.0 && \
   mkdir build && cd build && cmake .. -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE -DFMT_TEST=OFF && \
   make install -j$(nproc) && \
   cd ../.. && \
   rm -rf fmt-9.1.0

RUN wget --no-check-certificate https://github.com/gabime/spdlog/archive/refs/tags/v1.10.0.zip && \
   unzip v1.10.0.zip && \
   cd spdlog-1.10.0 && \
   mkdir build && cd build && cmake .. -DSPDLOG_BUILD_PIC=TRUE -DSPDLOG_BUILD_EXAMPLE=OFF -DSPDLOG_INSTALL=ON -DSPDLOG_FMT_EXTERNAL=ON && \
   make install -j$(nproc) && \
   cd ../.. && \
   rm -rf spdlog-1.10.0

RUN wget --no-check-certificate https://github.com/Tencent/rapidjson/archive/refs/tags/v1.1.0.zip && \
   unzip v1.1.0.zip && \
   cd rapidjson-1.1.0 && \
   mkdir build && cd build && cmake .. -DRAPIDJSON_BUILD_DOC=OFF -DRAPIDJSON_BUILD_EXAMPLES=OFF -DRAPIDJSON_BUILD_TESTS=OFF && \
   make install -j$(nproc) && \
   cd ../.. && \
   rm -rf rapidjson-1.1.0

