FROM ubuntu:22.04

RUN apt-get update
RUN apt-get -y install iproute2 wireless-tools iw nano tcpdump inetutils-ping netcat
RUN apt-get -y install wpasupplicant
RUN apt-get -y install curl telnetd

COPY w.conf /w.conf
COPY w2.conf /w2.conf
COPY go.sh /
COPY service.sh /

RUN echo 'root:tpowah' | chpasswd

ENTRYPOINT ["/bin/bash"]
