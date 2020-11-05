#TODO: Normalize the naming of images
FROM vowpalwabbit/rl-ubuntu-1604

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

# Make RUN commands use `bash --login`:
SHELL ["/bin/bash", "--login", "-c"]

# Initialize conda in bash config fiiles:
RUN conda init bash

# Activate the environment, and make sure it's activated:
RUN conda activate test-python36

# Install baseline required tools
RUN apt-get update && \
    apt install -y --no-install-recommends \
    # C++
    gdb
