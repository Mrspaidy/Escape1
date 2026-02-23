FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server \
    cowsay \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN mkdir /ctf
WORKDIR /ctf

COPY ./src /ctf/

RUN chmod +x /ctf/challenge.sh

RUN useradd -m -d /ctf -s /ctf/challenge.sh ctf && \
    echo "ctf:ctfpass" | chpasswd

RUN chown -R root:ctf /ctf && \
    chmod -R 750 /ctf && \
    chmod 740 /ctf/flag.txt

RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]