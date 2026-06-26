FROM debian:bookworm
ENV DEBIAN_FRONTEND=noninteractive

ENV APP_PATH="/root/app"

RUN mkdir -p "$APP_PATH"

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    libc6 \
    libstdc++6 \
    zlib1g \
    libgcc-s1 \
    python3 \
    git \
    cmake \
    make \
    build-essential \
    libc6:i386 \
    libstdc++6:i386 \
    libncurses5:i386 \
    libtinfo5:i386 \
    libgcc-s1:i386 \
    lib32gcc-s1 \
    libsdl2-2.0-0:i386 \
    libopenal1:i386 \
    libglib2.0-0:i386 \
    libfontconfig1:i386 \
    libgl1:i386 \
    libgl1-mesa-dri:i386 \
    tmux \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y sudo && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    useradd -m -s /bin/bash admin && \
    echo "admin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ARG INSTALL_STEAMCMD=true
RUN if [ "$INSTALL_STEAMCMD" = "true" ]; then \
    mkdir -p /opt/steamcmd && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C /opt/steamcmd && \
    chmod -R 755 /opt/steamcmd && \
    ln -s /opt/steamcmd/steamcmd.sh /usr/local/bin/steamcmd; \
    fi

USER root
RUN echo "root:root" | chpasswd
USER admin
WORKDIR /home/admin

CMD ["/bin/bash"]
