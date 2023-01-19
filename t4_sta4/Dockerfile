FROM ubuntu:22.04

RUN apt-get update
RUN apt-get -y install iproute2 wireless-tools iw nano tcpdump inetutils-ping netcat
RUN apt-get -y install wpasupplicant
RUN apt-get -y install ssh 
RUN apt-get -y install curl

COPY w.conf /w.conf
COPY go.sh /
COPY service.sh /
ENTRYPOINT ["/bin/bash"]
