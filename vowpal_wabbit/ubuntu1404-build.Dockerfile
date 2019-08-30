FROM ubuntu:14.04

# Install baseline required tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    # C++
    build-essential g++ gcc git make wget \
    # Python
    python-setuptools python-dev python-software-properties \
    # Java
    maven \
    # default-jdk \ # does not exist in ${CurrentVersion}, so install "OpenJDK" below
    # Enable apt-add-repository
    software-properties-common \
    # 14.04-specifics
    # bsdtar - work around "Directory renamed before its status could be extracted"
    #          see https://github.com/docker/hub-feedback/issues/727#issuecomment-299533372
    #          not applying remap of tar => bsdtar, since it only impacts the clang-format
    #          install below
    bsdtar \
    # Dependencies
    libboost-dev \
    libboost-math-dev \
    libboost-python-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libssl-dev \
    zlib1g-dev \
 && export tar=bsdtar \
 # Do this cleanup every time to ensure minimal layer sizes
 # TODO: Turn this into a script
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}

# Install g++ 4.9 (first version that supports complete c++11. i.e. <regex>)
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test \
 && apt-get update \
 && apt-get install -y gcc-4.9 g++-4.9 \
 && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9 \
 && add-apt-repository -y --remove "ubuntu-toolchain-r-test" \
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
 && /usr/local/miniconda/bin/conda install -q conda-env \
 && /usr/local/miniconda/bin/conda create -q -n test-python27 python=2.7 wheel virtualenv pytest readme_renderer pandas cmake nomkl numpy boost py-boost scipy scikit-learn six joblib \
 && /usr/local/miniconda/bin/conda create -q -n test-python36 python=3.6 wheel virtualenv pytest readme_renderer pandas cmake nomkl numpy boost py-boost scipy scikit-learn six joblib \
 && /usr/local/miniconda/bin/conda clean -a \
 # init is needed to ensure that the environment is properly set up for "source activate"
 && /usr/local/miniconda/bin/conda init \
 && rm miniconda.sh

# Add Open JDK repo (including license agreement), install Java
RUN echo "oracle-java11-installer shared/accepted-oracle-license-v1-2 select true" | \
    debconf-set-selections \
 && add-apt-repository -y ppa:openjdk-r/ppa \
 && apt-get update \
 && apt install -y openjdk-11-jdk \
 # Do this cleanup every time to ensure minimal layer sizes
 # TODO: Turn this into a script
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}

# Download maven dependencies
RUN wget https://raw.githubusercontent.com/VowpalWabbit/vowpal_wabbit/master/java/pom.xml.in \
 && mvn dependency:resolve -f pom.xml.in \
 && rm pom.xml.in

# Cleanup
# TODO: Turn this into a script
RUN apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}

# Download clang-format 7.0
RUN wget http://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-14.04.tar.xz \
 && bsdtar xvf clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-14.04.tar.xz \
 && mv clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-14.04/bin/clang-format /usr/local/bin \
 && rm -rf clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-14.04/ clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-14.04.tar.xz

# Non-layer configuration
# Set environment variables used by build
ENV PATH="/usr/local/miniconda/bin:${PATH}"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/"