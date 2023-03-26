ARG ARCH=amd64
FROM ${ARCH}/debian:bullseye-slim

ENV HOME=/root

WORKDIR ${HOME}

# Install some packages
RUN apt update && apt install -y \
  build-essential \
  bzip2 \
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
  make \
  postgresql \
  software-properties-common \
  tk-dev \
  wget \
  xz-utils \
  zlib1g-dev \
  zsh

# Copy over basic zsh dotfiles
COPY assets/zsh/zshenv ./.zshenv

# Install oh-my-zsh https://ohmyz.sh/
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY assets/zsh/zshrc_base ./.zshrc

# Use zsh from here on out, use interactive mode to ensure .zshrc is (re)loaded
SHELL ["/bin/zsh", "--interactive", "-c"]

# Install and setup algorand devtools
RUN mkdir -p $ALGORAND_NODE
RUN curl -s -o update.sh https://raw.githubusercontent.com/algorand/go-algorand/rel/stable/cmd/updater/update.sh
RUN chmod 744 ./update.sh && ./update.sh -i -c stable -p $ALGORAND_NODE -d $ALGORAND_MAINNET/data -n

# Setup private node
COPY assets/algorand/template.json .
RUN goal network create -r $ALGORAND_PRIVNET -n privnet -t ./template.json

# Install algorand indexer
COPY --chmod=744 assets/algorand/install_algorand_indexer.sh .
RUN ./install_algorand_indexer.sh

# Setup language and locale (needed later for perl/psql)
RUN sed -i -e "s/# $LANG.*/$LANG UTF-8/" /etc/locale.gen && dpkg-reconfigure --frontend=noninteractive locales && update-locale LANG=$LANG

# Install Python and pyenv
ARG PYTHON_VERSION=3.11
RUN curl https://pyenv.run | bash
COPY assets/zsh/zshrc_pyenv .
RUN cat zshrc_pyenv >> ~/.zshrc && rm zshrc_pyenv
RUN pyenv install $PYTHON_VERSION && pyenv global $PYTHON_VERSION

# Install Node.js, npm (latest), yarn, pnpm
ARG NODEJS_VERSION=--lts
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
COPY assets/zsh/zshrc_nvm .
RUN cat zshrc_nvm >> ~/.zshrc && rm zshrc_nvm
COPY assets/nvm/default-packages ./.nvm/
RUN nvm install $NODEJS_VERSION

# Copy over script and configs for algod, kmd, and indexer
COPY --chmod=744 assets/algorand/start_algorand_services.sh .
COPY assets/algorand/config.json assets/algorand/kmd_config.json ./
