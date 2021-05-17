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
        build-essential cmake g++ \
        # VW Test deps
        libboost-test-dev netcat git python-is-python3 \
        # VW Boost deps
        libboost-dev libboost-program-options-dev libboost-math-dev libboost-system-dev \
        # VW Other deps
        libflatbuffers-dev zlib1g-dev \
        # Clang tools
        clang-format clang-tidy \
        # RLClientLib deps
        libssl-dev libcpprest-dev \
    && rm -rf /var/lib/apt/lists/*
