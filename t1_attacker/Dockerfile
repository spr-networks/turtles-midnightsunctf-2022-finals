FROM ubuntu:22.04

RUN apt-get update
RUN apt-get -y install iproute2 wireless-tools iw nano tcpdump inetutils-ping netcat
RUN apt-get -y install  wpasupplicant
RUN apt-get -y install openssh-server

COPY go.sh /

RUN echo "root:mutant_n1nj4_turtle" | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Need to wait for orchestrator to run go.sh
ENTRYPOINT ["/bin/bash"]
