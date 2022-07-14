FROM ubuntu:20.04

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt install --yes --no-install-recommends \
        # Generic requirements
        ca-certificates \
        # Core build tools
        build-essential cmake g++ make wget ninja-build curl valgrind gdb \
        # Java (default-jdk === OpenJDK)
        maven default-jdk \
        # VW Test deps
        libboost-test-dev netcat git python3 python3-pip \
        # VW Boost deps
        libboost-dev libboost-program-options-dev libboost-math-dev libboost-system-dev \
        # VW Other deps
        libflatbuffers-dev zlib1g-dev \
        # Required for documentation generation
        doxygen graphviz \
        # Clang tools
        clang-format clang-tidy \
        # Required to run apt-get in the container
        sudo \
 # Do this cleanup every time to ensure minimal layer sizes
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}

RUN git clone https://github.com/google/googletest.git googletest \
 && cd googletest \
 && git checkout "release-1.10.0"  \
 && cmake -B build -S . -G Ninja -DCMAKE_BUILD_TYPE=Release \
 && cmake --build build --target install \
 && cd .. \
 && rm -rf googletest

# Download Maven dependencies
RUN wget https://raw.githubusercontent.com/VowpalWabbit/vowpal_wabbit/master/java/pom.xml.in \
 && mvn dependency:resolve -f pom.xml.in \
 && rm pom.xml.in

# Non-layer configuration
# Set environment variables used by build
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/"

# Mark VW repos as safe
RUN git config --global --add safe.directory "*"
