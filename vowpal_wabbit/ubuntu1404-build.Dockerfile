FROM ubuntu:14.04

# Install baseline required tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    # C++
    build-essential g++ gcc git make wget \
    # Python
    python-setuptools python-dev python-software-properties \
    # Java
    # maven \ # Cannot be installed using apt-get as the version is too old. It uses http by default and will not connect to the central repo.
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
    # Required to run apt-get in the container
    sudo \
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
 && for filename in /opt/cmake/bin/*; do echo Registering $filename; ln -fs $filename /usr/local/bin/`basename $filename`; done \
 && rm cmake-$version.$build-Linux-x86_64.sh

RUN wget https://github.com/google/flatbuffers/archive/v1.12.0.tar.gz \
 && tar -xzf v1.12.0.tar.gz \
 && cd flatbuffers-1.12.0 \
 && mkdir build \
 && cd build \
 && cmake -G "Unix Makefiles" -DFLATBUFFERS_BUILD_TESTS=Off -DFLATBUFFERS_INSTALL=On -DCMAKE_BUILD_TYPE=Release -DFLATBUFFERS_BUILD_FLATHASH=Off .. \
 && make install -j 4 \
 && cd ../../ \
 && rm -rf flatbuffers-1.12.0 \
 && rm v1.12.0.tar.gz
 
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

# Download new version of Maven, as apt version does not use https as default.
RUN wget https://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp \
   && sudo tar xf /tmp/apache-maven-3.6.3-bin.tar.gz -C /usr/local \
   && sudo ln -s /usr/local/apache-maven-3.6.3 /usr/local/maven \
   && rm -rf /tmp/apache-maven-3.6.3-bin.tar.gz \
   && sudo update-ca-certificates -f

# Workaround for bug: https://bugs.launchpad.net/ubuntu/+source/maven/+bug/1764406
ENV MAVEN_OPTS="-Djavax.net.ssl.trustStorePassword=changeit"
ENV M2_HOME="/usr/local/maven"
ENV MAVEN_HOME="/usr/local/maven"
ENV PATH="/usr/local/miniconda/bin:${M2_HOME}/bin:${PATH}"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/"

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
