FROM ubuntu:24.04

# Upgrade
RUN apt update && apt upgrade -y

# Install uv
# Ref: https://docs.astral.sh/uv/guides/integration/docker/#installing-uv
# Ref: https://github.com/fastapi/full-stack-fastapi-template/blob/master/backend/Dockerfile
COPY --from=ghcr.io/astral-sh/uv:0.4.15 /uv /bin/uv

#-- Install package
#     git        : for dev
#     curl       : for install nodejs
#     less, vim  : utility package
RUN apt install -y \
    git \
    curl \
    less vim

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


#-- nodejs install
#   Ref: https://qiita.com/suzuk12345/items/652f19de4c92c58d055d
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
RUN export NVM_DIR="$HOME/.nvm" && \
    . $NVM_DIR/nvm.sh && \
    nvm install --lts

#-- persist container
COPY ./bin/docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]
# CMD ["bash", "-c" "while :; do sleep 10000; done"]
