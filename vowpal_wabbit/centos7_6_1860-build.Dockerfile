FROM centos:centos7.6.1810

RUN yum -y updateinfo \
   && yum install -y \
   # C++ to bootstrap
   gcc-c++ gcc git make wget help2man \
   # Java
   maven \
   # Dependencies
   boost-static glibc-static \
   # gcc-9.2 pre-requisites
   bzip2 bison yacc flex \
   # Java
   java-11-openjdk

# Install CMake 3.13
RUN version=3.13 && build=5 \
   && mkdir ~/temp-cmake \
   && cd ~/temp-cmake \
   && wget https://cmake.org/files/v$version/cmake-$version.$build-Linux-x86_64.sh \
   && mkdir /opt/cmake \
   && sh cmake-$version.$build-Linux-x86_64.sh --prefix=/opt/cmake --skip-license \
   && ln -s /opt/cmake/bin/cmake /usr/bin/cmake \
   && rm -f cmake-$version.$build-Linux-x86_64.sh

# Install gcc-9.2
RUN wget ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-9.2.0/gcc-9.2.0.tar.gz \
   && tar xfz gcc-9.2.0.tar.gz \
   && cd gcc-9.2.0 \
   && ./contrib/download_prerequisites \
   && ./configure --disable-multilib --enable-languages=c,c++ --with-pic \
   && make \
   && make install

# Update path so it uses gcc 9.2
ENV PATH="/usr/local/bin:${PATH}"

# Install zlib
RUN wget -O zlib.tar.gz 'https://zlib.net/fossils/zlib-1.2.8.tar.gz' \
   && tar xvzf zlib.tar.gz \
   && cd zlib-1.2.8 \
   && ./configure --static --archs=-fPIC \ 
   && make \ 
   && make install

# Install boost (use bjam -j16 on your beefy machine)
RUN wget -O boost.tar.gz 'https://sourceforge.net/projects/boost/files/boost/1.70.0/boost_1_70_0.tar.gz/download' \
   && tar -xvzf boost.tar.gz \
   && cd boost_1_70_0 \
   && ./bootstrap.sh --prefix=boost_output --with-libraries=program_options,system,thread,test,chrono,date_time,atomic \
   && ./bjam cxxflags=-fPIC cflags=-fPIC -a install \
   && /usr/bin/cp -f boost_output/lib/libboost_system.a boost_output/lib/libboost_program_options.a /usr/lib64

# Download maven dependencies
RUN wget https://raw.githubusercontent.com/VowpalWabbit/vowpal_wabbit/master/java/pom.xml.in \
   && mvn dependency:resolve -f pom.xml.in \
   && rm -f pom.xml.in

# Cleanup
RUN rm -rf boost.tar.gz gcc-9.2.0.tar.gz zlib* \
   && chmod +x /usr/local/libexec/gcc/x86_64-pc-linux-gnu/9.2.0/cc1plus

# Non-layer configuration
# Set environment variables used by build
ENV LD_LIBRARY_PATH="/usr/local/lib64:${LD_LIBRARY_PATH}"
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.222.b10-0.el7_6.x86_64
ENV BOOSTROOT=/boost_1_70_0/boost_output
ENV PATH="/usr/local/libexec/gcc/x86_64-pc-linux-gnu/9.2.0:${PATH}"