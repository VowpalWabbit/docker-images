FROM vowpalwabbit/ubuntu1804-build

# Add remaining binary boost libraries, and Python3 Libs (need to build onnxruntime shared object)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libboost-random-dev \
    libboost-filesystem-dev \
    libboost-regex-dev \
    libboost-thread-dev \
    libboost-chrono-dev \
    libboost-atomic-dev \
    libboost-date-time-dev \
    libssl-dev \
    # OnnxRuntime dep
    python3-dev \
 # Do this cleanup every time to ensure minimal layer sizes
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}

RUN git clone https://github.com/Microsoft/cpprestsdk.git casablanca \
 && cd casablanca/Release \
 # Checkout 2.10.1 version of cpprestsdk
 && git checkout e8dda215426172cd348e4d6d455141f40768bf47 \
 && cmake -S . -B build -G Ninja -DBUILD_TESTS=Off -DBUILD_SAMPLES=Off \
 && cmake --build build --target install \
 && cd .. \
 && rm -rf casablanca

# Install onnxruntime
RUN git clone https://github.com/Microsoft/onnxruntime.git \
 && cd ./onnxruntime \
 && git checkout tags/v1.0.0 \
 && git submodule update --init \
 && ./build.sh --build_shared_lib --ctest_path echo --config Release \
 && cd build/Linux/Release \
 && make install -j ${nproc} \
 && cd ../../../.. \
 && rm -rf onnxruntime
