#!/bin/bash

if [ -z "${USER}" ]; then
    echo "ERROR: We need USER to be set!"; exit 100
fi

if [ -z "${HOST_UID}" ]; then
    echo "ERROR: We need HOST_UID be set" ; exit 100
fi

if [ -z "${HOST_GID}" ]; then
    echo "ERROR: We need HOST_GID be set" ; exit 100
fi

echo "USER      = $USER"
echo "HOST_UID  = $HOST_UID"
echo "HOST_GID  = $HOST_GID"

# reset user_?id to either new id or if empty old (still one of above
# might not be set)
USER_UID=${HOST_UID:=$UID}
USER_GID=${HOST_GID:=$GID}

# Create Group
groupadd ${USER_GID} > /dev/null 2>&1

# Create user
useradd ${USER} --shell /bin/bash --create-home --uid ${USER_UID} --gid ${USER_GID} > /dev/null 2>&1

echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers

chown -R ${USER_UID}:${USER_GID} /home/${USER} > /dev/null 2>&1

# switch to current user
su "${USER}"

# enter to bash and execute command 
echo "enter to /bin/bash and execute command $@"

exec /bin/bash