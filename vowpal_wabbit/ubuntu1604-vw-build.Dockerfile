FROM ubuntu:16.04

# Install build tools
RUN apt update && apt install -y --no-install-recommends \
    gcc g++ libboost-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev \
    libboost-math-dev libboost-test-dev libboost-python-dev zlib1g-dev cmake make software-properties-common \
    python-setuptools python-dev build-essential maven wget git netcat default-jdk \
  && rm -rf /var/lib/apt/lists/*

# Install python tools
RUN easy_install pip && \
  pip install cpp-coveralls

# Install Miniconda and setup environment
RUN wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh && \
  bash miniconda.sh -b -p /opt/miniconda && \
  hash -r && \
  /opt/miniconda/bin/conda config --set always_yes yes --set changeps1 no && \
  /opt/miniconda/bin/conda update -q conda && \
  /opt/miniconda/bin/conda create -q -n test-python27 python=2.7 nomkl numpy scipy scikit-learn pytest readme_renderer pandas six virtualenv wheel && \
  /opt/miniconda/bin/conda clean -a

# Download Maven dependencies
RUN wget https://raw.githubusercontent.com/VowpalWabbit/vowpal_wabbit/master/java/pom.xml.in && \
  mvn dependency:resolve -f pom.xml.in && \
  rm pom.xml.in

# Set environment variables used by build
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"

# Download clang-format 7.0
RUN wget http://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz && \
  tar xvf clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz && \
  mv clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/bin/clang-format /usr/local/bin && \
  rm -rf clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/ clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz
