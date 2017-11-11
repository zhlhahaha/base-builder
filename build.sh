#!/usr/bin/env bash

export ROOTFS=/rootfs
mkdir -p $ROOTFS

for i in "$@"
do
case $i in
    -p=*|--packages=*)
    PACKAGES="${i#*=}"
    shift
    ;;
    -d=*|--dev-packages=*)
    DEV_PACKAGES="${i#*=}"
    shift
    ;;
    *)
        echo "Unknow argument"
    ;;
esac
done

if [[ -z $PACKAGES ]]; then
    echo "Nothing to install :("
    exit 1
fi

echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
echo "@main http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

echo "@v24 http://dl-cdn.alpinelinux.org/alpine/v2.4/main" >> /etc/apk/repositories
echo "@v25 http://dl-cdn.alpinelinux.org/alpine/v2.5/main" >> /etc/apk/repositories
echo "@v26 http://dl-cdn.alpinelinux.org/alpine/v2.6/main" >> /etc/apk/repositories
echo "@v27 http://dl-cdn.alpinelinux.org/alpine/v2.7/main" >> /etc/apk/repositories
echo "@v30 http://dl-cdn.alpinelinux.org/alpine/v3.0/main" >> /etc/apk/repositories
echo "@v31 http://dl-cdn.alpinelinux.org/alpine/v3.1/main" >> /etc/apk/repositories
echo "@v32 http://dl-cdn.alpinelinux.org/alpine/v3.2/main" >> /etc/apk/repositories
echo "@v33 http://dl-cdn.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories
echo "@v34 http://dl-cdn.alpinelinux.org/alpine/v3.4/main" >> /etc/apk/repositories
echo "@v35 http://dl-cdn.alpinelinux.org/alpine/v3.5/main" >> /etc/apk/repositories
echo "@v36 http://dl-cdn.alpinelinux.org/alpine/v3.6/main" >> /etc/apk/repositories
echo "@v37 http://dl-cdn.alpinelinux.org/alpine/v3.7/main" >> /etc/apk/repositories

apk --repositories-file /etc/apk/repositories --update --allow-untrusted --initdb --no-cache --root $ROOTFS add $PACKAGES

if [[ ! -z $DEV_PACKAGES ]]; then
    apk --repositories-file /etc/apk/repositories --update add $DEV_PACKAGES
fi

cp /etc/passwd $ROOTFS/etc/passwd
cp /etc/group $ROOTFS/etc/group

if [ -d /src ]; then
    export SRC=/src
fi

if [ -f /runner/entrypoint.sh ]; then
    chmod +x /runner/entrypoint.sh
    /runner/entrypoint.sh
fi

rm -rf $ROOTFS/var/cache/apk/*
cd $ROOTFS
tar czvf ../build/rootfs.tar.gz .

exit 0
