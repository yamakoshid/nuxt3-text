FROM ubuntu:latest

WORKDIR /work

RUN apt update

#-- nodejs install
#   Ref: https://qiita.com/suzuk12345/items/652f19de4c92c58d055d
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
RUN export NVM_DIR="$HOME/.nvm" && \
    . $NVM_DIR/nvm.sh && \
    nvm install --lts

#-- sqlite3 install
RUN apt install -y sqlite3

#-- Postgresql client install
# Ref: https://www.postgresql.org/download/linux/ubuntu/

# Requered to RUN /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
RUN apt install -y gnupg2

RUN apt install -y postgresql-common
RUN /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y
RUN apt install -y postgresql-client-16

#-- python install
#   Ref: https://github.com/pyenv/pyenv?tab=readme-ov-file

#---- build dependency
#       skip interactive prompt and install tzdata
RUN DEBIAN_FRONTEND=noninteractive TZ=Asia/Tokyo apt-get install -y tzdata
RUN apt update; apt install -y build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

RUN apt install -y git
RUN curl https://pyenv.run | bash
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    && echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(pyenv init -)"' >> ~/.bashrc \
    && bash \
    && . ~/.bashrc && pyenv install 3.12 && pyenv global 3.12

#-- Install utility package
RUN apt install -y less vim 

#-- Install dependency for Cypress(E2ETest Package)
#   Ref: https://docs.cypress.io/guides/getting-started/installing-cypress#Linux-Prerequisites
# RUN apt-get install libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libnss3 libxss1 libasound2 libxtst6 xauth xvfb

#-- persist container
CMD ["bash", "-c" "while :; do sleep 10000; done"]
