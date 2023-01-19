FROM ubuntu:22.04

RUN apt-get update
RUN apt-get -y install iproute2 wireless-tools iw nano tcpdump inetutils-ping netcat
RUN apt-get -y install wpasupplicant
RUN apt-get -y install curl
RUN apt-get -y install build-essential libavahi-client-dev avahi-daemon avahi-utils
RUN apt-get -y install ssh
COPY w.conf /w.conf
COPY go.sh /
COPY service.sh /

COPY config/avahi-daemon.conf /etc/avahi
COPY code code
RUN gcc code/mdns-client.c -lavahi-common -lavahi-client -o /mdns-client

ENTRYPOINT ["/bin/bash"]
