FROM alpine:3.10

LABEL maintainer="Dmitry Stoletoff info@imega<dot>ru" \
    version="1.9.1" \
    description="Create rootfs for docker."

VOLUME ["/build", "/src", "/runner"]

ADD build.sh /

RUN apk --update add bash

ENTRYPOINT ["/build.sh"]
