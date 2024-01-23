## Docker image offline download

## Sometimes it is needed to download docker images for offline usage. If your behind a firewall you might run in to issues starting docker
## images using docker-compose.yml as it is nearly impossible to have you proxy settings injected everywhere. This is when this nifty tool
## comes handy... Download the images, copy and import them to your docker host later. Containers will start up smoothly. Remember to use
## version tags, not stable as the underlying images can change if they are updated by the maintainer.

## Warning! This .sh is not meant to be run. It is a collection of commands to be used on a command-line, one after another

## Get the download script
wget https://raw.githubusercontent.com/moby/moby/master/contrib/download-frozen-image-v2.sh

## Install prerequisities
sudo apt install jq -y

## Make the script executable
chmod +x download-frozen-image-v2.sh

## Download images
## !! this is a 'total' random collection of docker images. You need to use your own images
./download-frozen-image-v2.sh wazuh-odfe wazuh/wazuh-odfe:4.2.5
./download-frozen-image-v2.sh opendistro-for-elasticsearch amazon/opendistro-for-elasticsearch:1.13.2
./download-frozen-image-v2.sh wazuh-kibana-odfe wazuh/wazuh-kibana-odfe:4.2.5

## Compress images for transfer (will tar each directory to separate archive)
find . -maxdepth 1 -mindepth 1 -type d -exec tar cvf {}.tar {}  \;

## Copy them to target host with docker(-compose) installed

## Import compressed images to docker
ls -1 *.tar | xargs --no-run-if-empty -L 1 docker load -i

## Run!
## Foreground:
docker-compose up

## Background:
docker-compose up -d
