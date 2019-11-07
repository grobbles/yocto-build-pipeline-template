FROM ubuntu:16.04

# Install all packages
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath \
        socat cpio python python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping libsdl1.2-dev \
        xterm tar locales curl libelf-dev linux-generic libelf-dev nano
# libelf-devel elfutils-libelf-devel

# Set up locales
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get -y install locales apt-utils sudo \
    && dpkg-reconfigure locales  \
    && locale-gen en_US.UTF-8  \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# setup time 
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "Europe/Berlin" > /etc/timezone
RUN apt-get -y install tzdata \
    && dpkg-reconfigure -f noninteractive tzdata

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# Clean up APT when done.                                                        
RUN apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*   

# Replace dash with bash                                                         
RUN rm /bin/sh && ln -s bash /bin/sh

# Add entry point, we use entrypoint.sh to mapping host user to container
COPY entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

