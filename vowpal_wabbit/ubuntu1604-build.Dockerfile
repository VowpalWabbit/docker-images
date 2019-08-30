FROM ubuntu:16.04

# Install baseline required tools
RUN apt-get update && \
    apt install -y --no-install-recommends \
    # C++
    build-essential g++ gcc git make wget \
    # Python
    python-setuptools python-dev \
    # Java (default-jdk === OpenJDK)
    maven default-jdk \
    # Enable apt-add-repository
    software-properties-common \
    # 16.04-specifics
    # netcat-openbsd - work around an issue where the default netcat does not work for
    #                  daemon-mode tests
    netcat-openbsd \
    # Dependencies
    libboost-dev \
    libboost-math-dev \
    libboost-program-options-dev \
    libboost-python-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libssl-dev \
    zlib1g-dev \
 # Do this cleanup every time to ensure minimal layer sizes
 # TODO: Turn this into a script
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}

# Install CMake 3.13
RUN version=3.13 && build=5 \
 && mkdir ~/temp-cmake \
 && cd ~/temp-cmake \
 && wget https://cmake.org/files/v$version/cmake-$version.$build-Linux-x86_64.sh \
 && mkdir /opt/cmake \
 && sh cmake-$version.$build-Linux-x86_64.sh --prefix=/opt/cmake --skip-license \
 && ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake \
 && rm cmake-$version.$build-Linux-x86_64.sh

# Install Python tools, Miniconda, and setup environment
RUN easy_install pip \
 && pip install cpp-coveralls wheel virtualenv pytest readme_renderer \
 && wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh \
 && bash miniconda.sh -b -p /usr/local/miniconda \
 && hash -r \
 && /usr/local/miniconda/bin/conda config --set always_yes yes --set changeps1 no \
 && /usr/local/miniconda/bin/conda update -q conda \
 #&& /usr/local/miniconda/bin/conda install -q conda-env \
 && /usr/local/miniconda/bin/conda create -q -n test-python27 python=2.7 wheel virtualenv pytest readme_renderer pandas cmake nomkl numpy boost py-boost scipy scikit-learn six joblib \
 && /usr/local/miniconda/bin/conda create -q -n test-python36 python=3.6 wheel virtualenv pytest readme_renderer pandas cmake nomkl numpy boost py-boost scipy scikit-learn six joblib \
 && /usr/local/miniconda/bin/conda clean -a \
 # init is needed to ensure that the environment is properly set up for "source activate"
 && /usr/local/miniconda/bin/conda init \
 && rm miniconda.sh

# Download Maven dependencies
RUN wget https://raw.githubusercontent.com/VowpalWabbit/vowpal_wabbit/master/java/pom.xml.in \
 && mvn dependency:resolve -f pom.xml.in \
 && rm pom.xml.in

# Cleanup
# TODO: Turn this into a script
RUN apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}

# Download clang-format 7.0
RUN wget http://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz \
 && tar xvf clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz \
 && mv clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/bin/clang-format /usr/local/bin \
 && rm -rf clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/ clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz

# Non-layer configuration
# Set environment variables used by build
ENV PATH="/usr/local/miniconda/bin:${PATH}"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"