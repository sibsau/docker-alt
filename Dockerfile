# Dockerfile to create Alt linux base images
# Create base image with mkimage-apt.sh script
#

FROM scratch
MAINTAINER "Anton Goroshkin" <neobht@sibsau.ru>
ENV TARROOTFS https://github.com/sibsau/docker-alt/raw/master/rootfs.tar.xz
#ADD ${TARROOTFS} /
RUN curl -fsSL "${TARROOTFS}" \
	| tar -xzC /
