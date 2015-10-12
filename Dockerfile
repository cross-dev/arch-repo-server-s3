FROM crossdev/arch-repo-server
MAINTAINER Roman Saveljev <roman.saveljev@haltian.com>

RUN \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-key update && \
    apt-get -y update && \
    apt-get -y install build-essential libfuse-dev \
        libcurl4-openssl-dev libxml2-dev mime-support \
        automake libtool wget tar pkg-config libssl-dev \
        fuse curl

RUN \
    curl -L https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.79.tar.gz | tar xz -C /usr/src/ && \
    cd /usr/src/s3fs-fuse-1.79 && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make && \
    make install && \
    rm -rf /usr/src/s3fs-fuse-1.79

RUN \
    chmod a+rwx /var/lib/repos && \
    mkdir -p -m 0775 /var/cache/s3fs && \
    chown nobody /var/cache/s3fs && \
    echo "user_allow_other" >>/etc/fuse.conf

USER nobody
COPY bin/ /bin/
ENTRYPOINT ["/bin/entrypoint"]
