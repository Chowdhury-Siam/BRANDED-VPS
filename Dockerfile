FROM ubuntu:22.04

# Update and install necessary packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    sudo \
    curl \
    ffmpeg \
    git \
    locales \
    nano \
    python3-pip \
    screen \
    ssh \
    unzip \
    wget

# Configure locale
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_21.x | bash - && \
    apt-get install -y nodejs

# Set environment variables
ENV LANG en_US.utf8
ARG LOCALTONET_TOKEN
ENV LOCALTONET_TOKEN=${LOCALTONET_TOKEN}

# Download and set up LocalTonet
RUN wget -O localtonet.zip https://localtonet.com/download/localtonet-linux-x64.zip && \
    unzip localtonet.zip && \
    chmod 777 ./localtonet && \
    echo "./localtonet authtoken ${LOCALTONET_TOKEN} &&" >> /start

# Set up SSH
RUN mkdir /run/sshd && \
    echo '/usr/sbin/sshd -D' >> /start && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'root:branded' | chpasswd && \
    service ssh start && \
    chmod 755 /start

# Expose ports
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306

# Start the service
CMD /start
