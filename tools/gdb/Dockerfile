FROM alpine:latest AS sources

WORKDIR /src
RUN apk add curl tar patch;
RUN curl -L https://launchpad.net/gdb-linaro/7.4/7.4-2012.04/+download/gdb-linaro-7.4-2012.04.tar.bz2 | tar xvjf - --strip-components=1;
COPY ./patches /patch
RUN find /patch -name '*.patch' -exec patch -p1 -i {} \; ;

FROM ubuntu:12.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i 's/archive.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
      build-essential \
      linux-libc-dev \
      texinfo \
      libncurses5-dev \
      libreadline-dev \
      libexpat1-dev \
      python-dev \
      zlib1g-dev \
      bison flex && \
    rm -rf /var/lib/apt/lists/*;
COPY --from=sources /src /build
WORKDIR /build

RUN ./configure --prefix=/dist --target x86_64-linux-gnu --build=x86_64-linux-gnu --host=x86_64-linux-gnu;
RUN make -j$(nproc);
RUN make install;

FROM alpine:latest AS packaging

RUN apk add binutils tar;

WORKDIR /dist;
COPY --from=builder /dist /gdb-linaro
RUN strip /gdb-linaro/bin/* && mkdir -p /dist && tar cvzf /dist/gdb.tar.gz -C / gdb-linaro;
