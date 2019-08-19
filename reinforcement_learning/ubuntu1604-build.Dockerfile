FROM vowpalwabbit/ubuntu1604-build

# Assumes baseline tools, vw dependencies, GCC 4.9, and CMake 3.13

# Add remaining binary boost libraries, and Python3 Libs (need to build onnxruntime shared object)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libboost-random-dev \
    libboost-filesystem-dev \
    libboost-regex-dev \
    python3-dev \
 # Do this cleanup every time to ensure minimal layer sizes
 # TODO: Turn this into a script
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}

# Install cpprestsdk
RUN git clone https://github.com/Microsoft/cpprestsdk.git casablanca \
 && cd casablanca/Release \
 # Checkout 2.10.1 version of cpprestsdk
 && git checkout e8dda215426172cd348e4d6d455141f40768bf47 \
 && mkdir build \
 && cd build \
 && cmake .. -DBUILD_TESTS=Off -DBUILD_SAMPLES=Off \
 && make -j4 \
 && make install \
 && cd ../../../ \
 && rm -rf casablanca

# Install flatbuff
RUN git clone https://github.com/google/flatbuffers.git \
 && cd ./flatbuffers \
 # 1.10.0 release commit
 && git checkout 925c1d77fcc72636924c3c13428a34180c30f96f \
 && mkdir build \
 && cd build \
 && cmake .. -DFLATBUFFERS_BUILD_TESTS=Off -DFLATBUFFERS_INSTALL=On -DCMAKE_BUILD_TYPE=Release -DFLATBUFFERS_BUILD_FLATHASH=Off \
 && make -j4 \
 && make install \
 && cd ../../ \
 && rm -rf flatbuffers

# Install onnxruntime
RUN git clone https://github.com/Microsoft/onnxruntime.git \
 && cd ./onnxruntime \
 && git checkout tags/v0.5.0 \
 && git submodule update --init \
 && ./build.sh --build_shared_lib --ctest_path echo --config Release \
 && cd build/Linux/Release \
 && make install \
 && cd ../../../.. \
 && rm -rf onnxruntime