FROM alpine:latest
WORKDIR /usr/src
ADD mymount.c /usr/src/mymount.c
ADD s3backer /usr/bin/s3backer
ADD sleep.sh /sleep.sh
RUN apk add --update alpine-sdk autoconf automake curl-dev fuse-dev openssl-dev zlib-dev expat-dev pkgconfig wget tar curl fuse openssl zlib expat && \
    wget https://github.com/archiecobbs/s3backer/archive/1.4.1.tar.gz -O s3backer.tar.gz && \
    tar -zxf s3backer.tar.gz -C /usr/src --strip=1 && \
    sed -i.bak s/bash/sh/g autogen.sh && \
    ./autogen.sh && \
    ./configure && \
    make && \
    cp s3backer /usr/bin/s3backer.orig && \
    gcc -Wall -fPIC -shared -o mymount.so mymount.c -ldl -D_FILE_OFFSET_BITS=64 && \
    cp mymount.so /mymount.so && \
    apk del alpine-sdk autoconf automake curl-dev fuse-dev openssl-dev zlib-dev expat-dev pkgconfig wget tar && rm -rf /var/cache/apk/* && cd / && rm -rf /usr/src
WORKDIR /root
CMD /sleep.sh
