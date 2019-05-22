FROM alpine:3.8

MAINTAINER Dmitry Stoletoff <info@imega.ru>

VOLUME ["/build", "/src", "/runner"]

ADD build.sh /

RUN apk --update add bash

ENTRYPOINT ["/build.sh"]
