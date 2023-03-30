FROM debian:11.6

LABEL org.opencontainers.image.source https://github.com/deptagency/algorand-devcontainer

ENV HOME=/root

WORKDIR ${HOME}

RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y \
  apt-transport-https \
  build-essential \
  bzip2 \
  ca-certificates \
  curl \
  git \
  gnupg2 \
  jq \
  libbz2-dev \
  libffi-dev \
  liblzma-dev \
  libncurses5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libxml2-dev \
  libxmlsec1-dev \
  llvm \
  locales \
  lsb-release \
  make \
  postgresql \
  software-properties-common \
  tk-dev \
  wget \
  xz-utils \
  zlib1g-dev \
  zsh

# Install Docker CE CLI
RUN curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list \
    && apt update \
    && apt install -y docker-ce-cli

# Install Docker Compose
RUN export LATEST_COMPOSE_VERSION=$(curl -sSL "https://api.github.com/repos/docker/compose/releases/latest" | grep -o -P '(?<="tag_name": ").+(?=")') \
    && curl -sSL "https://github.com/docker/compose/releases/download/${LATEST_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Setup some env variables
RUN echo 'export LANG="en_US.UTF-8"' >> .zshenv
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> .zshenv
RUN echo 'export PATH="$PYENV_ROOT/bin:$HOME/.local/bin:$PATH"' >> .zshenv
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> .zshenv

# Install oh-my-zsh https://ohmyz.sh/
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Use zsh from here on out, use interactive+login mode to ensure .zshrc is (re)loaded
SHELL ["/bin/zsh", "--interactive", "--login", "-c"]

# Setup language and locale (needed later for perl/psql)
RUN sed -i -e "s/# $LANG.*/$LANG UTF-8/" /etc/locale.gen && dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=$LANG

# Install Python and pyenv
ARG PYTHON_VERSION=3.10
RUN curl https://pyenv.run | bash
RUN echo 'eval "$(pyenv init -)"' >> .zshrc
RUN pyenv install $PYTHON_VERSION && pyenv global $PYTHON_VERSION
RUN curl -sSL https://install.python-poetry.org | python -
RUN python -m pip install --user pipx
RUN pipx install algokit

# Install Node.js, npm (latest), yarn, pnpm
ARG NODEJS_VERSION=--lts
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> .zshrc
RUN echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> .zshrc
RUN nvm install --default $NODEJS_VERSION
RUN npm install -g npm yarn pnpm
