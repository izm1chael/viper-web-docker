FROM ubuntu:latest
MAINTAINER izm1chael

# Database Configuration
ARG db_connection=sqlite:///root/.viper/viper.db
ENV db_connection=${db_connection}
# Log file location
ARG log_file=/var/log/viper.log
ENV log_file=${log_file}
# Web UI configuration
ARG username=admin
ENV username=${username}
ARG password=admin
ENV password=${password}
ARG port=8080
ENV port=${port}
ARG host=127.0.0.1
ENV host=${host}
# Virus Total Configuration
ARG virustotal_private=False
ENV virustotal_private=${virustotal_private}
ARG virustotal_intel=False
ENV virustotal_intel=${virustotal_intel}
ARG virustotal_key
ENV virustotal_key=${virustotal_key}
# Cuckoo Sandbox configuration
ARG cuckoo_modified=False
ENV cuckoo_modified=${cuckoo_modified}
ARG cuckoo_host=http://localhost:8090
ENV cuckoo_host=${cuckoo_host}
ARG cuckoo_web=http://localhost:8000
ARG auth_token
ENV auth_token=${auth_token}



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

# Install Viper Web
WORKDIR /opt
RUN git clone https://github.com/viper-framework/viper-web.git && \
    cd viper-web && \
    pip3 install -r requirements.txt 

RUN mkdir /opt/scripts
ADD /scripts/configure.sh /opt/scripts/configure.sh 
RUN bash /opt/scripts/configure.sh 
ADD /scripts/start.sh /opt/scripts/start.sh
RUN chmod +x /opt/scripts/start.sh
RUN chmod +x /opt/viper-web/viper-web

# Clean tmp_build
RUN rm -rf ~/tmp_build

EXPOSE 8080
HEALTHCHECK CMD curl --fail http://localhost:8080 || exit 1   
VOLUME /var/malware /root/.viper

WORKDIR /opt/scripts
ENTRYPOINT ["/opt/scripts/start.sh"]
