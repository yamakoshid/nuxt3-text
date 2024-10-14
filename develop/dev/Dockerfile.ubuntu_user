FROM ubuntu:24.04

# Upgrade
RUN apt update && apt upgrade -y

# Set UID and GID(default 1000 and 1000)
ARG UID=1000
ARG GID=1000

# Modify default user "ubuntu" (uid 1000) with UID and GID
RUN usermod  -u ${UID} -m -d /home/ubuntu ubuntu && \
    groupmod -g ${GID} ubuntu

# Switch to the default user
USER ubuntu

# Set the workdir
WORKDIR /home/ubuntu/work

#-- persist container
COPY ./bin/docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]
# CMD ["bash", "-c" "while :; do sleep 10000; done"]
