FROM ubuntu:18.04

# Install baseline required tools
RUN apt-get update && \
    apt install -y --no-install-recommends \
    # C++
    build-essential g++ gcc git make wget ninja-build curl valgrind \
    # Java (default-jdk === OpenJDK)
    maven default-jdk \
    clang-format clang-tidy \
    # test dependencies
    libboost-test-dev netcat python3 \
    # VW Boost deps
    libboost-dev libboost-program-options-dev libboost-math-dev libboost-system-dev \
    # VW Other deps
    zlib1g-dev \
    # Required for documentation generation
    doxygen graphviz \
    # Required to run apt-get in the container
    sudo \
 # Do this cleanup every time to ensure minimal layer sizes
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}

# Install CMake 3.18.4
RUN version=3.18 && build=4 \
 && mkdir ~/temp-cmake \
 && cd ~/temp-cmake \
 && wget https://cmake.org/files/v$version/cmake-$version.$build-Linux-x86_64.sh \
 && mkdir /opt/cmake \
 && sh cmake-$version.$build-Linux-x86_64.sh --prefix=/opt/cmake --skip-license \
 && for filename in /opt/cmake/bin/*; do echo Registering $filename; ln -fs $filename /usr/local/bin/`basename $filename`; done \
 && rm cmake-$version.$build-Linux-x86_64.sh

# Install FlatBuffers 1.12.0
RUN version=1.12.0 && \
 wget https://github.com/google/flatbuffers/archive/v$version.tar.gz \
 && tar -xzf v$version.tar.gz \
 && cd flatbuffers-$version \
 && cmake -B build -S . -G Ninja -DFLATBUFFERS_BUILD_TESTS=Off -DFLATBUFFERS_INSTALL=On -DCMAKE_BUILD_TYPE=Release -DFLATBUFFERS_BUILD_FLATHASH=Off \
 && cmake --build build --target install \
 && cd .. \
 && rm -rf flatbuffers-$version \
 && rm v$version.tar.gz

RUN git clone https://github.com/fmtlib/fmt.git \
 && cd fmt \
 && git checkout 835b910e7d758efdfdce9f23df1b190deb3373db \
 && cmake -B build -S . -G Ninja -DFMT_DOC=Off -DFMT_INSTALL=On -DFMT_TEST=Off -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
 && cmake --build build --target install \
 && cd .. \
 && rm -rf fmt

RUN git clone https://github.com/gabime/spdlog.git \
 && cd spdlog \
 && git checkout de0dbfa3596a18cd70a4619b6a9766847a941276 \
 && cmake -B build -S . -G Ninja -DSPDLOG_BUILD_EXAMPLE=Off -DSPDLOG_INSTALL=On -DSPDLOG_FMT_EXTERNAL=On -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
 && cmake --build build --target install \
 && cd .. \
 && rm -rf spdlog

# Download Maven dependencies
RUN wget https://raw.githubusercontent.com/VowpalWabbit/vowpal_wabbit/master/java/pom.xml.in \
 && mvn dependency:resolve -f pom.xml.in \
 && rm pom.xml.in

# Non-layer configuration
# Set environment variables used by build
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/"
