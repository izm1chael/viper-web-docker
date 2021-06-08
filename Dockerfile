FROM ubuntu:latest
MAINTAINER izm1chael

ARG web_user=admin
ARG web_password=admin
ARG web_host=127.0.0.1
ARG web_port=8080
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
WORKDIR /opt
RUN git clone git clone https://github.com/viper-framework/viper && \
    cd viper && \
    pip3 install .
WORKDIR /opt/viper/viper/data
RUN touch viper.conf
RUN echo "[web]" >> viper.conf
RUN echo "host = ${web_host}" >> viper.conf
RUN echo "port = ${web_port}" >> viper.conf
RUN echo "tls = False" >> viper.conf
RUN echo "admin_username = ${web_user}" >> viper.conf
RUN echo "admin_password = ${web_password}" >> viper.conf
RUN echo "[virustotal]" >> viper.conf
RUN echo "virustotal_has_private_key = ${virustotal_private_key}" >> viper.conf
RUN echo "virustotal_has_intel_key = ${virustotal_intel_key}" >> viper.conf
RUN echo "virustotal_key = ${virustotal_key}" >> viper.conf
RUN echo "[yara]" >> viper.conf
RUN echo "repositories = https://github.com/Neo23x0/signature-base.git" >> viper.conf

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
