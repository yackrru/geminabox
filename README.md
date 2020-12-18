![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/7a6163/geminabox)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/7a6163/geminabox)

# Docker image of Gem in a Box

## Overview
[Geminabox](https://github.com/geminabox/geminabox) lets you host your own gems, and push new gems to it just like with rubygems.org.
This docker image include Geminabox on runtime of the official [ruby:2.7-alpine](https://hub.docker.com/_/ruby).

## Usage

### Quick start
Do mapping local port to listening 9292 port on the container, which activate geminabox.
In order to open local port 8080 up to container, docker run command as follows.
```bash
docker run -d -p 8080:9292 ttksm/geminabox:latest
```
After executing the command, you can browse geminabox where http://localhost:8080.
<br>
Then, executing the follwing command enables gem networking your own geminabox.
```bash
gem sources -a http://localhost:8080/
```
Finally, you can upload or delete gems through browsing geminabox, and install gems by cli like as follows.
```bash
gem install GEM
```

### Options
Configure two environment variables activate basic authentication. Default inactive.
After activate Basic authentication, you need authentication when upload or delete gems.
#### `BASIC_USER`
username for basic authentication.
#### `BASIC_PASS`
password for basic authentication.
<br>
<br>
Docker run command as follows.
```bash
docker run -d -p 8080:9292 -e BASIC_USER=username -e BASIC_PASS=password ttksm/geminabox:latest
```
And in order to enabling auto authentication when you install gems on cli, you should run the command.
```bash
gem sources -a http://username:password@localhost:8080/
```

## Configurations

### persistent volume for gems
Gems are stored on the directory `/var/geminabox-data` on the geminabox container.
So, mount a directory on the host or a docker volume to `/var/geminabox-data`, gems persists.
For example, mount current directory,
```bash
docker run -d -p 8080:9292 --mount type=bind,src=$PWD,dst=/var/geminabox-data ttksm/geminabox:latest
```

### docker-compose.yml
Basic Authentication is activated and docker volume mounted to persist gems.
```yaml
version: '3.7'

services:
  geminabox:
    image: ttksm/geminabox:latest
    container_name: geminabox
    environment:
      - BASIC_USER=username
      - BASIC_PASS=password
    ports:
      - "8080:9292"
    restart: always
    volumes:
      - type: volume
        source: geminabox-data
        target: /var/geminabox-data

volumes:
  geminabox-data:
```
