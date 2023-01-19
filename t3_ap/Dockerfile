FROM ubuntu:22.04

RUN apt-get update
RUN apt-get -y install iproute2 wireless-tools iw nano tcpdump inetutils-ping netcat
RUN apt-get -y install hostapd
RUN apt-get -y install wpasupplicant
RUN apt-get -y install iptables

COPY h.conf /h.conf
COPY go.sh /
# Need to wait for orchestrator to run go.sh
ENTRYPOINT ["/bin/bash"]
