FROM ubuntu:latest
MAINTAINER izm1chael

ARG web_user=admin
ARG web_password=admin
ARG virustotal_private_key=False
ARG virustotal_intel_key=False
ARG virustotal_key

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

USER root
RUN pip3 install lief

# Install Viper from Source
USER root
RUN pip3 install lief
RUN pip3 install viper-framework
RUN viper

RUN mkdir /var/malware


WORKDIR /root/.viper
RUN sed -i "/#admin_username/c admin_username\ =\ "${web_user}"" viper.conf
RUN sed -i "/#admin_password/c admin_password\ =\ "${web_password}"" viper.conf
RUN sed -i "/virustotal_has_private_key/c virustotal_has_private_key\ =\ "${virustotal_private_key}"" viper.conf
RUN sed -i "/virustotal_has_intel_key/c virustotal_has_intel_key\ =\ "${virustotal_intel_key}"" viper.conf
RUN sed -i "/virustotal_key/c virustotal_key\ =\ "${virustotal_key}"" viper.conf
RUN sed -i "/storage_path/c storage_path\ =\ /var/malware"${virustotal_key}"" viper.conf


# Install Viper Web
WORKDIR /opt
RUN git clone https://github.com/viper-framework/viper-web.git && \
    cd viper-web && \
    pip3 install -r requirements.txt 

# Clean tmp_build
RUN rm -rf ~/tmp_build

EXPOSE 8080
HEALTHCHECK CMD curl --fail http://localhost:8080 || exit 1   

WORKDIR /opt/viper-web
CMD ["./viper-web", "-H", "0.0.0.0", "-p", "8080"]
