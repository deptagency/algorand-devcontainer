# source image args
ARG PYTHON_VERSION=3.11
ARG ALPINE_VERSION=3.17

FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

LABEL org.opencontainers.image.source https://github.com/deptagency/algorand-devcontainer

# config args
ARG PIPX_VERSION=1.2.0
ARG POETRY_VERSION=1.4.1
ARG ALGOKIT_VERSION=1.0.1
ARG PNPM_VERSION=8.1.0
ARG YARN_VERSION=1.22.19
ARG USERNAME=dept

RUN apk update && apk add --no-cache \
  build-base \
  curl \
  docker \
  docker-cli-compose \
  git \
  jq \
  libc-dev \
  libffi-dev \
  musl-dev \
  nodejs \
  npm \
  openssh \
  python3-dev \
  sudo \
  zsh

# setup group and user
RUN addgroup -S ${USERNAME} && adduser ${USERNAME} -g "" -s /bin/zsh -D -S -G ${USERNAME} && adduser ${USERNAME} docker
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# setup some env vars
RUN echo 'export PNPM_HOME="$HOME/.pnpm"' >> ~/.zshenv
RUN echo 'export PATH="$PATH:$PNPM_HOME:$HOME/.yarn/bin:$HOME/.local/bin"' >> ~/.zshenv

# setup pnpm and yarn (must be done as root)
RUN npm config set prefix ~/.local
RUN npm install -g pnpm@${PNPM_VERSION} yarn@${YARN_VERSION}

# use zsh from now on
SHELL ["/bin/zsh", "--login", "--interactive", "-c"]

# setup pipx, poetry, and algokit
RUN python3 -m pip install --user pipx==${PIPX_VERSION}
RUN pipx install poetry==${POETRY_VERSION}
RUN pipx install algokit==${ALGOKIT_VERSION}

# setup oh my zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# setup startup script
COPY --chown=${USERNAME}:${USERNAME} --chmod=744 entrypoint.sh .
VOLUME /var/run/docker.sock
ENTRYPOINT ./entrypoint.sh && /bin/zsh --login --interactive
