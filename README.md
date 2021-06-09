
<p align="center">
  <img src="https://viper-framework.readthedocs.io/en/latest/_images/viper.png" />
</p>

# Viper Framework Web Interface

Viper is a binary analysis and management framework. Its fundamental objective is to provide a solution to easily organize your collection of malware and exploit samples as well as your collection of scripts you created or found over the time to facilitate your daily research.

### Docker CLI

    docker run -d \
      --name=aleph \
      -p 5000:5000 \
      -p 6881/udp:6881/udp \
      -v /path/to/malware/samples:/opt/aleph/samples \
      -v /path/to/your/unprocessed/samples:/opt/aleph/unprocessed_samples \
      -v /path/to/your/elasticsearch/data:/usr/share/elasticsearch/data
      -v /path/to/your/elasticsearch/config:/usr/share/elasticsearch/config
      --restart unless-stopped \
      izm1chael/aleph



### Docker Compose
```
---
version: "2.1"
services:
  aleph:
    image:  izm1chael/aleph
    container_name: aleph
    volumes:
      - /path/to/malware/samples:/opt/aleph/samples \
      - /path/to/your/unprocessed/samples:/opt/aleph/unprocessed_samples \
      - /path/to/your/elasticsearch/data:/usr/share/elasticsearch/data
      - /path/to/your/elasticsearch/config:/usr/share/elasticsearch/config
    ports:
      - 5000:5000
    restart: unless-stopped
```
