#TODO: Normalize the naming of images
FROM vowpalwabbit/rl-ubuntu-1604

# Install baseline required tools
RUN apt-get update && \
    apt install -y --no-install-recommends \
    # C++
    gdb