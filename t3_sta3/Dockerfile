FROM ubuntu/redis:6.0-21.04_edge

RUN sed -i s/security.ubuntu.com/old-releases.ubuntu.com/ /etc/apt/sources.list
RUN sed -i s/archive.ubuntu.com/old-releases.ubuntu.com/ /etc/apt/sources.list


RUN apt-get update
RUN apt-get -y install iproute2 wireless-tools iw nano tcpdump inetutils-ping netcat
RUN apt-get -y install wpasupplicant
RUN apt-get -y install curl
RUN apt-get install -y build-essential libavahi-client-dev avahi-daemon avahi-utils

#make life very easy for the newbs
RUN cp /usr/lib/x86_64-linux-gnu/liblua5.1.so.0 /usr/lib/x86_64-linux-gnu/liblua5.1.so

COPY w.conf /w.conf
COPY w2.conf /w2.conf
COPY go.sh /
COPY service.sh /

COPY config/avahi-daemon.conf /etc/avahi
COPY code/mdns-publish.c /mdns-publish.c
COPY code/mdns-client.c /mdns-client.c
RUN gcc /mdns-publish.c -lavahi-common -lavahi-client -o /mdns-publish
WORKDIR /
ENTRYPOINT ["/bin/bash"]
