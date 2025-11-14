FROM alpine:3.22

RUN apk update && apk add --no-cache openssh sudo python3

RUN adduser -D -h /home/alpine -s /bin/sh node \
	&& echo "node:node1234" | chpasswd \
	&& adduser node wheel \
	&& echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN ssh-keygen -A

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
	&& sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config \
	&& echo "PermitRootLogin no" >> /etc/ssh/sshd_config \
	&& echo "AllowUsers node" >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
