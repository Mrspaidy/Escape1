FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

# Install SSH + required tools
RUN apt-get update && apt-get install -y \
    openssh-server \
    cowsay \
    && rm -rf /var/lib/apt/lists/*

# Prepare SSH
RUN mkdir /var/run/sshd

# Create ctf directory
RUN mkdir /ctf
WORKDIR /ctf

# Create restricted user
RUN useradd -m -d /ctf -s /bin/bash ctf && \
    echo "ctf:ctfpass" | chpasswd

# Copy challenge files
COPY ./src /ctf/

# Secure permissions
RUN chown -R root:ctf /ctf && \
    chmod -R 750 /ctf && \
    chmod 740 /ctf/flag.txt

# Auto-start challenge on login
RUN echo "/ctf/challenge.sh" >> /ctf/.bashrc && \
    echo "exit" >> /ctf/.bashrc

# SSH security settings
RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]