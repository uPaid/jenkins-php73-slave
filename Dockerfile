FROM php:7.3-cli

RUN apt-get update && apt-get install -y \
  git \
  curl \
  wget \
  unzip \
  openssh-server \
  software-properties-common

RUN mkdir -p /usr/share/man/man1 \
&& apt-get update && apt-get install -y openjdk-8-jdk-headless ca-certificates-java && update-alternatives --config java

ENV JAVA_OPTS -Dfile.encoding=UTF-8 \
              -Dsun.jnu.encoding=UTF-8

COPY php.ini /usr/local/etc/php/

RUN sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd
RUN useradd -m -s /bin/bash jenkins

RUN echo "jenkins:jenkins" | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]