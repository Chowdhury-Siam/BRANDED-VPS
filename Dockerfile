FROM ubuntu:22.04
RUN apt-get -y update && apt-get -y upgrade -y && apt-get install -y sudo
RUN sudo apt-get install -y curl ffmpeg git locales nano python3-pip screen ssh unzip wget  
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN curl -sL https://deb.nodesource.com/setup_21.x | bash -
RUN sudo apt-get install -y nodejs
ENV LANG en_US.utf8
ARG LOCALTONET_TOKEN
ENV LOCALTONET_TOKEN=${LOCALTONET_TOKEN}
RUN wget -O localtonet.zip https://localtonet.com/download/localtonet-linux-x64.zip
RUN unzip localtonet.zip
RUN echo "./localtonet authtoken ${LOCALTONET_TOKEN} &&" >>/start
RUN mkdir /run/sshd
RUN echo '/usr/sbin/sshd -D' >>/start
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config 
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo root:branded|chpasswd
RUN service ssh start
RUN chmod 755 /start
EXPOSE 80 8888 8080 443 5130 5131 5132 5133 5134 5135 3306
CMD  /start
