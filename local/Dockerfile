FROM ubuntu:20.04

RUN apt update && apt install openssh-server sudo python3 -y

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 node \
	&& echo 'node:node1234' | chpasswd

RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
