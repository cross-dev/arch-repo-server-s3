#FROM crossdev/arch-repo-server
FROM debian:8
MAINTAINER Roman Saveljev <roman.saveljev@haltian.com>

USER root

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-key update && \
	apt-get -y update && \
    apt-get -y install build-essential libfuse-dev \
        libcurl4-openssl-dev libxml2-dev mime-support \
        automake libtool wget tar

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y install curl

RUN \
    curl -L https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.79.tar.gz | tar xz -C /usr/src/
RUN \
    cd /usr/src/s3fs-fuse-1.79 && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make && \
    make install

COPY bin/ /bin/

#ENTRYPOINT ["/bin/entrypoint"]
