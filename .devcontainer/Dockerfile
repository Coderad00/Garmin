FROM debian:bullseye

ARG DOCKER_USER=developer
ARG DOCKER_UID=1000
ARG DOCKER_GID=1000

RUN apt-get update && apt-get install -y \
    at-spi2-core \
    libatk1.0-0 \
    libx11-xcb1\
    x11-apps \
    x11-utils \
    libx11-dev \
    libxtst-dev \
    libnss3 \
    libjpeg62-turbo \
    libwebkit2gtk-4.0-dev \
    fish \
    default-jdk \
    curl \
    unzip \
    git \
    ca-certificates \
    libsecret-1-0 \
    libglib2.0-0 \
    libgdk-pixbuf2.0-0 \
    libxss1 \
    libgtk-3-0 \
    && ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so.62 /usr/lib/x86_64-linux-gnu/libjpeg.so.8 \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g ${DOCKER_GID} ${DOCKER_USER} && \
    useradd -m -u ${DOCKER_UID} -g ${DOCKER_GID} ${DOCKER_USER}

COPY ../tools/ConnectIQ /opt/sdk

ENV CIQ_SDK_PATH=/opt/sdk
ENV PATH="$CIQ_SDK_PATH/bin:$PATH"
RUN ln -s /opt/sdk/Sdks/connectiq-sdk-lin-8.1.0-* /opt/sdk/Sdks/latest
ENV PATH="/opt/sdk/Sdks/latest/bin:$PATH"
RUN chmod +x /opt/sdk/Sdks/latest/bin/*

USER ${DOCKER_USER}
WORKDIR /home/${DOCKER_USER}
USER root
RUN chsh -s /usr/bin/fish ${DOCKER_USER}
ENV MB_HOME=/opt/sdk/Sdks/latest
ENV DISPLAY=$DISPLAY
ENV XAUTHORITY=/tmp/.Xauthority

RUN echo "export SHELL=/usr/bin/fish" >> /home/${DOCKER_USER}/.bashrc
RUN echo "exec /usr/bin/fish" >> /home/${DOCKER_USER}/.bashrc