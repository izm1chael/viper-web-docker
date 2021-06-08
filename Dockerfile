FROM ubuntu:latest
MAINTAINER izm1chael

ENV YARA_VERSION       4.1.0
ENV PYEXIF_VERSION     0.2.0
ENV ANDROGUARD_VERSION 1.9

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

USER root
RUN apt-get update && apt-get install -y \
    git \
    gcc \
    python3-dev \
    python3-pip \
    curl \
    libtool \
    autoconf \
    flex \
    swig \
    libssl-dev \
    libffi-dev \
    ssdeep \
    libfuzzy-dev \
    unrar-free \
    p7zip-full \
    pff-tools \
    exiftool \
    clamav-daemon \
    tor \
    libdpkg-perl \
    automake \
    libtool \
    make \
    gcc \
    pkg-config \
    libmagic-dev \
    wget \
    androguard \
    libimage-exiftool-perl && \
  rm -rf /var/lib/apt/lists/*

# Make Tmp Dir
RUN mkdir ~/tmp_build

# Install Yara
WORKDIR ~/tmp_build
RUN wget https://github.com/VirusTotal/yara/archive/refs/tags/v${YARA_VERSION}.tar.gz -O yara-${YARA_VERSION}.tar.gz
RUN tar -zxf yara-${YARA_VERSION}.tar.gz && \
  cd yara-${YARA_VERSION} && \
  bash bootstrap.sh
RUN pip3 install yara-python

# Create Viper User
RUN groupadd -r viper && \
  useradd -r -g viper -d /home/viper -s /sbin/nologin -c "Viper User" viper && \
  mkdir /home/viper && \
  chown -R viper:viper /home/viper

USER root
RUN pip3 install lief
RUN pip3 install viper-framework

WORKDIR /opt
RUN git clone https://github.com/viper-framework/viper-web.git && \
    cd viper-web && \
    pip3 install -r requirements.txt 

# Clean tmp_build
RUN rm -rf ~/tmp_build


EXPOSE 8080
WORKDIR /opt/viper-web
CMD ["./viper-web", "-H", "0.0.0.0", "-p", "8080"]
