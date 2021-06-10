

<p align="center">
  <img src="https://viper-framework.readthedocs.io/en/latest/_images/viper.png" />
</p>




[![Docker Image CI](https://github.com/izm1chael/viper-web-docker/actions/workflows/docker-image.yml/badge.svg)](https://github.com/izm1chael/viper-web-docker/actions/workflows/docker-image.yml)[![Publish Docker image to Docker Hub](https://github.com/izm1chael/viper-web-docker/actions/workflows/publish_dockerhub.yml/badge.svg)](https://github.com/izm1chael/viper-web-docker/actions/workflows/publish_dockerhub.yml)[![Publish Docker image to Github](https://github.com/izm1chael/viper-web-docker/actions/workflows/publish_github.yml/badge.svg)](https://github.com/izm1chael/viper-web-docker/actions/workflows/publish_github.yml)

  
  
# Viper Framework Web Interface

Viper is a binary analysis and management framework. Its fundamental objective is to provide a solution to easily organize your collection of malware and exploit samples as well as your collection of scripts you created or found over the time to facilitate your daily research.

### Docker CLI

    docker run -d \
      --name=viper \
      -p 8080:8080 \
      -v /path/to/your/malware/samples:/var/malware \
      -v /path/to/your/config/data:/root/.viper
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
    volumes:
      -/path/to/your/malware/samples:/var/malware
      - /path/to/your/config/data:/root/.viper
    restart: unless-stopped
```
Additional configuration:

|Parameter | Function |
| ---- | --- |
| `-e username=admin` | Set username for web interface |
| `-e password=changeme` | Set password for web interface |
| `-e password=changeme` | Set password for web interface |
| `-e db_connection=sqlite:///root/.viper/viper.db` | Configure the database connection type example shown below <br/> Examples: <br/> postgresql://foo:bar@localhost:5432 <br/> mydatabase\mysql://foo:bar@localhost/mydatabase <br/> mysql+pymysql://foo:bar@localhost/mydatabase|
| `-e log_file=/var/log/viper.log` | Set the log file location |
| `-e port=8080` | Set the port the web interface is available on |
| `-e host=127.0.0.1` | Set the address of the web interface |
| `-e virustotal_private=False` | Do you have a private Virustotal Key |
| `-e virustotal_intel=False` | Do you have a Virustotal intelligence key |
| `-e virustotal_key=YourVirustotalAPI` | Your Virustotal API key |
| `-e cuckoo_modified=False` | Do you want to connect to your Cuckoo instance|
| `-e cuckoo_host=http://localhost:8090` | Your Cuckoo API location|
| `-e cuckoo_web=http://localhost:8080` | Your Cuckoo Web UI location|
| `-e auth_token=*********` | Your Cuckoo auth token|
