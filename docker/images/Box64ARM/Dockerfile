FROM debian:bookworm
ENV DEBIAN_FRONTEND=noninteractive

ENV APP_PATH="/root/app"

RUN dpkg --add-architecture i386 && \
    dpkg --add-architecture armhf && \
    dpkg --add-architecture amd64 && \
    apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    libc6 \
    libstdc++6 \
    zlib1g \
    libgcc-s1 \
    libc6:amd64 \
    libstdc++6:amd64 \
    zlib1g:amd64 \
    python3 \
    git \
    cmake \
    make \
    build-essential \
    libc6:i386 \
    libstdc++6:i386 \
    libgcc-s1:i386 \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    libc6-dev-armhf-cross \
    libc6:armhf \
    libstdc++6:armhf \
    libgcc-s1:armhf

RUN git clone https://github.com/ptitSeb/box64.git /tmp/box64 && \
    mkdir -p /tmp/box64/build && \
    cd /tmp/box64/build && \
    cmake .. -DARM_DYNAREC=ON -DBOX32=ON -DBOX32_BINFMT=ON && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /tmp/box64

RUN git clone https://github.com/ptitSeb/box86.git /tmp/box86 && \
    mkdir -p /tmp/box86/build && \
    cd /tmp/box86/build && \
    cmake .. -DARM_DYNAREC=ON \
             -DCMAKE_SYSTEM_NAME=Linux \
             -DCMAKE_SYSTEM_PROCESSOR=arm \
             -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc \
             -DCMAKE_CXX_COMPILER=arm-linux-gnueabihf-g++ && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /tmp/box86

CMD ["/bin/bash"]
