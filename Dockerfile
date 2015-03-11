# app server, base ubuntu
# include sshd, java, node.js, supervisord

FROM ubuntu:14.04
MAINTAINER yinheli <me@yinheli.com>

## install wget tar git sshd mysql ...
RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
    apt-get update && apt-get install -y \
    curl vim iptables telnet wget tar make gcc git \
    mysql-server \
    openssh-server supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /var/lib/mysql/mysql


RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/session\s*required\s*pam_loginuid.so/session optional pam_loginuid.so/g' /etc/pam.d/sshd && \
    mkdir /var/run/sshd && \
    /bin/echo 'root:henry!123qwe'|chpasswd && \
    locale-gen en_US.UTF-8 && update-locale en_US.UTF-8


### install java ###

# download && install java
RUN wget --progress=bar --no-check-certificate \
    -O /tmp/jdk.tar.gz \
    --header "Cookie: oraclelicense=a" \
    http://download.oracle.com/otn-pub/java/jdk/7u72-b14/server-jre-7u72-linux-x64.tar.gz && \
    tar xzf /tmp/jdk.tar.gz && \
    mkdir -p /usr/local/jdk && \
    mv jdk1.7.0_72/* /usr/local/jdk/ && \
    rm -rf jdk1.7.0_72 && rm -f /tmp/jdk.tar.gz && \
    chown root:root -R /usr/local/jdk && \
    update-alternatives --install /usr/bin/java java /usr/local/jdk/bin/java 1 && \
    update-alternatives --set java /usr/local/jdk/bin/java

ENV JAVA_HOME /usr/local/jdk

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf


### other ###

# set env
ENV PATH $PATH:\$JAVA_HOME/bin

EXPOSE 22


CMD ["/usr/bin/supervisord"]
