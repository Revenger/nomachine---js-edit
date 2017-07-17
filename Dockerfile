FROM debian:jessie
MAINTAINER Revenger, edited from: JS Minet

ENV DEBIAN_FRONTEND=noninteractive
ENV NOMACHINE_PACKAGE_NAME nomachine_5.3.9_6_amd64.deb
ENV NOMACHINE_MD5 050eadd9f037e31981c7e138bfcfbe80
ENV BUILD_PACKAGES="curl cups mate-desktop-environment-core pulseaudio ssh vim xterm sudo eiskaltdcpp-gtk3 eiskaltdcpp-emoticons" 

# Extra DC++ packages not installed for referance
# eiskaltdcpp-scripts eiskaltdcpp-sounds php5-cli

RUN apt-get update && apt-get install -y $BUILD_PACKAGES \
&& rm -rf /var/lib/apt/lists/*

ADD nxserver.sh /

RUN curl -fSL "http://download.nomachine.com/download/5.3/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
&& echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - \
&& dpkg -i nomachine.deb \
&& groupadd -r nomachine -g 433 \
&& useradd -u 431 -r -g nomachine -d /home/nomachine -s /bin/bash -c "NoMachine" nomachine \
&& mkdir /home/nomachine \
&& chown -R nomachine:nomachine /home/nomachine \
&& echo 'nomachine:nomachine' | chpasswd \
&& rm -f nomachine.deb \
&& service ssh start \
&& chmod +x /nxserver.sh

ENTRYPOINT ["/nxserver.sh"]

EXPOSE 22 4000
