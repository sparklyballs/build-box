FROM phusion/baseimage:0.9.16
MAINTAINER sparklyballs <sparkly@madeupemail.com>

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# output volume
VOLUME /deb-out

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

# update apt and install build area dependencies
apt-get update && \
apt-get install -y unzip unrar wget cmake git python-dev build-essential autoconf libtool pkg-config ruby-dev && \
gem install fpm && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true )) && \


# make build area folders 
mkdir -p /root/build-area /root/project/debout  && \

# export deb script
echo "#!/bin/bash" > /root/debout.sh && \
echo "cp /root/project/debout/*.deb /deb-out/" >> /root/debout.sh && \
echo "chown -R nobody:users /deb-out" >> /root/debout.sh && \
echo "chmod 755 -R /deb-out" >> /root/debout.sh && \
chmod +x /root/debout.sh


