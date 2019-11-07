FROM ubuntu:19.04 

# Install all packages
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install gawk wget unzip python python3 python3-pip python3-pexpect debianutils
# libelf-devel elfutils-libelf-devel

# Set up locales
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get -y install locales apt-utils sudo \
    && dpkg-reconfigure locales  \
    && locale-gen en_US.UTF-8  \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Setup python environment 
RUN pip3 install unittest-xml-reporting pytest pytest-incremental \
        paramiko scp numpy colorama terminaltables artifactory pathlib twine numpy unittest-xml-reporting pathlib scp artifactory fabric django

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

# Add User
ENV USER_NAME puTestEnvironment
RUN adduser --system --group --shell /bin/sh $USER_NAME && mkdir /home/$USER_NAME/bin

# Replace dash with bash                                                         
RUN rm /bin/sh && ln -s bash /bin/sh

USER $USER_NAME

