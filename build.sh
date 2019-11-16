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

cat << 'EOF' > /etc/apk/repositories
http://dl-cdn.alpinelinux.org/alpine/v3.10/main
http://dl-cdn.alpinelinux.org/alpine/v3.10/community
@testing      http://dl-cdn.alpinelinux.org/alpine/edge/testing
@main         http://dl-cdn.alpinelinux.org/alpine/edge/main
@community    http://dl-cdn.alpinelinux.org/alpine/edge/community
@edge-testing   http://dl-cdn.alpinelinux.org/alpine/edge/testing
@edge-main      http://dl-cdn.alpinelinux.org/alpine/edge/main
@edge-community http://dl-cdn.alpinelinux.org/alpine/edge/community
@stable-main      http://dl-cdn.alpinelinux.org/alpine/latest-stable/main
@stable-community http://dl-cdn.alpinelinux.org/alpine/latest-stable/community
@v24          http://dl-cdn.alpinelinux.org/alpine/v2.4/main
@v25          http://dl-cdn.alpinelinux.org/alpine/v2.5/main
@v26          http://dl-cdn.alpinelinux.org/alpine/v2.6/main
@v27          http://dl-cdn.alpinelinux.org/alpine/v2.7/main
@v30          http://dl-cdn.alpinelinux.org/alpine/v3.0/main
@v31          http://dl-cdn.alpinelinux.org/alpine/v3.1/main
@v32          http://dl-cdn.alpinelinux.org/alpine/v3.2/main
@v33          http://dl-cdn.alpinelinux.org/alpine/v3.3/main
@v33community http://dl-cdn.alpinelinux.org/alpine/v3.3/community
@v34          http://dl-cdn.alpinelinux.org/alpine/v3.4/main
@v34community http://dl-cdn.alpinelinux.org/alpine/v3.4/community
@v35          http://dl-cdn.alpinelinux.org/alpine/v3.5/main
@v35community http://dl-cdn.alpinelinux.org/alpine/v3.5/community
@v36          http://dl-cdn.alpinelinux.org/alpine/v3.6/main
@v36community http://dl-cdn.alpinelinux.org/alpine/v3.6/community
@v37          http://dl-cdn.alpinelinux.org/alpine/v3.7/main
@v37community http://dl-cdn.alpinelinux.org/alpine/v3.7/community
@v38          http://dl-cdn.alpinelinux.org/alpine/v3.8/main
@v38community http://dl-cdn.alpinelinux.org/alpine/v3.8/community
@v39          http://dl-cdn.alpinelinux.org/alpine/v3.9/main
@v39community http://dl-cdn.alpinelinux.org/alpine/v3.9/community
@v310          http://dl-cdn.alpinelinux.org/alpine/v3.10/main
@v310community http://dl-cdn.alpinelinux.org/alpine/v3.10/community
@v311          http://dl-cdn.alpinelinux.org/alpine/v3.11/main
@v311community http://dl-cdn.alpinelinux.org/alpine/v3.11/community
EOF

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
