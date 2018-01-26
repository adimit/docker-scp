FROM alpine:3.7

MAINTAINER Aleksandar Dimitrov <aleks.dimitrov@gmail.com>

RUN apk add --no-cache sshpass openssh-client
