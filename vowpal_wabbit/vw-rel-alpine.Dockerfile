FROM vowpalwabbit/ubuntu2004-build AS build
ARG branch_or_tag=9.4.0
RUN git clone -b $branch_or_tag --depth=1 --recursive https://github.com/VowpalWabbit/vowpal_wabbit.git /vw

WORKDIR /vw
RUN cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DWARNINGS=Off -DSTATIC_LINK_VW=On -DBUILD_JAVA=Off -DBUILD_PYTHON=Off -DBUILD_TESTING=Off
RUN cmake --build build -t vw_cli_bin

FROM alpine:latest
COPY --from=build /vw/build/vowpalwabbit/cli/vw .
ENTRYPOINT ["./vw"]
