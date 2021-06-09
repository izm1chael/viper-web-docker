
<p align="center">
  <img src="https://viper-framework.readthedocs.io/en/latest/_images/viper.png" />
</p>
[![Docker Image CI](https://github.com/izm1chael/viper-web-docker/actions/workflows/docker-image.yml/badge.svg)](https://github.com/izm1chael/viper-web-docker/actions/workflows/docker-image.yml)

# Viper Framework Web Interface

Viper is a binary analysis and management framework. Its fundamental objective is to provide a solution to easily organize your collection of malware and exploit samples as well as your collection of scripts you created or found over the time to facilitate your daily research.

### Docker CLI

    docker run -d \
      --name=aleph \
      -p 8080:8080 \
      --restart unless-stopped \
      izm1chael/viper-web



### Docker Compose
```
---
version: "2.1"
services:
  viper:
    image:  izm1chael/viper-web
    container_name: viper
    ports:
      - 8080:8080
    restart: unless-stopped
```
