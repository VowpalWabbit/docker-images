FROM vowpalwabbit/ubuntu1604-build AS build
ARG branch_or_tag=8.9.1
RUN git clone -b $branch_or_tag --depth=1 --recursive https://github.com/VowpalWabbit/vowpal_wabbit.git /vw
WORKDIR vw
WORKDIR build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DWARNINGS=Off -DSTATIC_LINK_VW=On -DBUILD_JAVA=Off -DBUILD_PYTHON=Off -DBUILD_TESTS=Off
RUN make vw-bin -j $(cat nprocs.txt)

FROM alpine:latest
COPY --from=build /vw/build/vowpalwabbit/vw .
ENTRYPOINT ["./vw"]
