# build stage
FROM ubuntu:jammy AS build

# set environment variables to avoid interaction during package installation
ENV DEBIAN_FRONTEND=noninteractive

# update the package list and install build dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    cmake \
    pkg-config \
    ninja-build \
    zip \
    unzip \
    tar \
    dotnet-sdk-8.0 \
    && rm -rf /var/lib/apt/lists/*

# clone the specified repository and build the project
RUN git clone https://github.com/microsoft/learning-loop.git /tmp/learning-loop
WORKDIR /tmp/learning-loop
RUN git submodule update --init --recursive
RUN mkdir artifacts
RUN dotnet build ./OnlineTrainerExe/OnlineTrainerExe.csproj -c Release
RUN dotnet publish ./OnlineTrainerExe/OnlineTrainerExe.csproj -c Release --no-build -o /publish

# final runtime stage
FROM mcr.microsoft.com/dotnet/runtime:8.0 AS runtime

# set environment variables to avoid interaction during package installation
ENV DEBIAN_FRONTEND=noninteractive

# install only the necessary runtime dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && rm -rf /var/lib/apt/lists/*

# copy the published output from the build stage
COPY --from=build /publish /app
COPY --from=build /tmp/learning-loop/artifacts/rl_sim /app/rl_sim

WORKDIR /app

RUN chmod 555 onlinetrainer.sh
RUN chmod 555 vw-bin/vw-*
RUN chmod 555 rl_sim.sh
RUN chmod 555 rl_sim/rl_sim-*

ENTRYPOINT ["/bin/bash", "start-app.sh"]