FROM ubuntu:22.04

# Update and install necessary packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl ffmpeg git locales nano python3-pip screen ssh unzip wget

# Configure locale
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_21.x | bash -
RUN apt-get install -y nodejs

# Set up SSH
RUN apt-get install -y sudo
RUN mkdir /run/sshd
RUN echo '/usr/sbin/sshd -D' >> /start
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "root:root" | chpasswd
RUN service ssh start
RUN chmod 755 /start

# Expose ports
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306

# Set up LocalTonet
CMD /start
ARG LOCALTONET_TOKEN
ENV LOCALTONET_TOKEN=${LOCALTONET_TOKEN}
RUN wget -O localtonet.zip https://localtonet.com/download/localtonet-linux-x64.zip && \
    unzip localtonet.zip && \
    chmod 777 ./localtonet && \
    echo "./localtonet authtoken ${LOCALTONET_TOKEN} &&" >> /start
