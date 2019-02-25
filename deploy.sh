#!/bin/bash

apt update

apt -y dist-upgrade

apt -y autoremove

apt clean

apt-get install apt-transport-https ca-certificates curl software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt install docker-ce docker-ce-cli containerd.io -y

sudo docker run \
  --restart unless-stopped -d \
  —name steam-cache \
  -v /home/user/cache/steam/data:/data/cache \
  -v /home/user/cache/steam/logs:/data/logs \
  -p 192.168.1.50:80:80 \
  steamcache/generic:latest

sudo docker run \
  —restart unless-stopped -d \
  —name origin-cache \
  -v /home/user/cache/origin/data:/data/cache \
  -v /home/user/cache/origin/logs:/data/logs \
  -p 192.168.1.51:80:80 \
  steamcache/generic:latest

sudo docker run \
  —-restart unless-stopped -d \
  —-name blizzard-cache \
  -v /home/user/cache/blizzard/data:/data/cache \
  -v /home/user/cache/blizzard/logs:/data/logs \
  -p 192.168.1.52:80:80 \
  steamcache/generic:latest

sudo docker run \
  —-restart unless-stopped -d \
  —-name windows-cache \
  -v /home/user/cache/windows/data:/data/cache \
  -v /home/user/cache/windows/logs:/data/logs \
  -p 192.168.1.53:80:80 \
  steamcache/generic:latest

sudo docker run \
  —-restart unless-stopped -d \
  —-name steamcache-dns \
  -p 192.168.1.50:53:53/udp \
  -e UPSTREAM_DNS=192.168.1.121 \
  -e STEAMCACHE_IP=192.168.1.50 \
  -e ORIGINCACHE_IP=192.168.1.51 \
  -e BLIZZARDCACHE_IP=192.168.1.52 \
  -e WSUSCACHE_IP=192.168.1.53 \
  steamcache/steamcache-dns:latest

docker volume create portainer_data

docker run -d -p 9000:9000 -v /home/user/portainer/docker.sock:/var/run/docker.sock -v /home/user/portainer:/data portainer/portainer

docker run \
  --name guac \
  --restart always  -d \
  -p 8282:8080 \
  -v /home/user/guac/config:/config \
  -e "EXTENSIONS=auth-duo" \
  oznu/guacamole

docker run --name nginx --restart always -v /home/user/nginx:/etc/nginx -d -p 192.168.1.54:80:80 nginx