#TODO: Normalize the naming of images
FROM vowpalwabbit/rl-ubuntu-1604

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

# Install baseline required tools
RUN apt-get update && \
    apt install -y --no-install-recommends \
    # C++
    gdb
