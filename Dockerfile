# Dockerfile to create Alt linux base images
# Create base image with mkimage-apt.sh script
#

FROM scratch
MAINTAINER "Anton Goroshkin" <neobht@sibsau.ru>
ADD https://github.com/sibsau/docker-alt/raw/master/rootfs.tar.xz /
