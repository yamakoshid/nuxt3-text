#!/bin/bash

USERID=${DEV_CONTAINER_UID}
GROUPID=${DEV_CONTAINER_GID}
echo "Create User = $USERID. Group = $GROUPID"
groupadd -g $GROUPID dockeruser
useradd -m -s /bin/bash -u $USERID -g $GROUPID dockeruser
exec /usr/sbin/gosu dockeruser "$@"