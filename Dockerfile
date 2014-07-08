# This file creates a container that runs X11 and SSH services
# The ssh is used to forward X11 and provide you encrypted data
# communication between the docker container and your local 
# machine.
#
# Xpra allows to display the programs running inside of the
# container such as Firefox, LibreOffice, xterm, etc. 
# with disconnection and reconnection capabilities
#
# Xephyr allows to display the programs running inside of the
# container such as Firefox, LibreOffice, xterm, etc. 
#
# Fluxbox and ROX-Filer creates a very minimalist way to 
# manages the windows and files.
#
# Author: Roberto Gandolfo Hashioka
# Date: 07/28/2013


FROM ubuntu:14.04
MAINTAINER Roberto G. Hashioka "roberto_hashioka@hotmail.com"

RUN apt-get update
RUN apt-get dist-upgrade -f -y
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y curl
RUN curl http://winswitch.org/gpg.asc | apt-key add -
RUN echo "deb http://winswitch.org/ trusty main" > /etc/apt/sources.list.d/winswitch.list;

RUN apt-get update;
RUN apt-get install -y avahi-utils python-avahi libavahi-core-dev python-netifaces rox-filer ssh pwgen xserver-xephyr xdm fluxbox sudo libreoffice-base firefox libreoffice-gtk libreoffice-calc xterm rox-filer ssh pwgen xserver-xephyr xdm fluxbox sudo zip unzip wget axel git git-svn subversion vim software-properties-common python-software-properties   binfmt-support visualvm ttf-baekmuk ttf-unfonts-core   ctags vim-doc vim-scripts
RUN apt-get install -y winswitch xpra xvfb

RUN sed -i 's/DisplayManager.requestPort/!DisplayManager.requestPort/g' /etc/X11/xdm/xdm-config
RUN sed -i '/#any host/c\*' /etc/X11/xdm/Xaccess
RUN ln -s /usr/bin/Xorg /usr/bin/X
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

RUN apt-get -y install fuse  || :
RUN rm -rf /var/lib/dpkg/info/fuse.postinst
RUN apt-get -y install fuse

RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
RUN apt-get -y install oracle-java7-installer

ADD . /src

EXPOSE 22
CMD ["/bin/bash", "/src/startup.sh"]
