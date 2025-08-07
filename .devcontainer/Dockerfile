FROM debian:stable-slim

SHELL ["/bin/bash", "-c"]
RUN apt-get update && \
    apt-get install -y \
    locales \
    sudo \
    direnv

RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen

ARG USERNAME=code
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} -s /bin/bash && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/devcontainer && \
    chmod 0440 /etc/sudoers.d/devcontainer

COPY etc/nix.conf /etc/nix/nix.conf

ARG NIX_INSTALL_SCRIPT=https://nixos.org/nix/install
RUN curl -L ${NIX_INSTALL_SCRIPT} | sudo -u ${USERNAME} NIX_INSTALLER_NO_MODIFY_PROFILE=1 sh

COPY etc/devcontainer.sh /etc/profile.d/devcontainer.sh

COPY etc/bash.bashrc /etc/bash.bashrc

COPY etc/envrc /etc/envrc
ENV ENV="/etc/envrc" BASH_ENV="/etc/envrc"

COPY etc/direnv.toml /etc
ENV DIRENV_CONFIG=/etc

COPY --chmod=0755 docker-entrypoint.sh /docker-entrypoint.sh

USER ${USERNAME}
ENTRYPOINT [ "/docker-entrypoint.sh" ]

ONBUILD USER root

ONBUILD ARG USERNAME=code
ONBUILD ARG USER_UID=1000
ONBUILD ARG USER_GID=${USER_UID}

ONBUILD RUN \
    if [ -z ${USER_UID} ] || [ -z ${USER_UID} ] || [ -z ${USERNAME} ]; then exit 0; fi && \
    set -x && \
    if [ "$(id -u code)" != "${USER_UID}" ] || [ "$(id -g code)" != "${USER_GID}" ]; then \
        groupmod -g ${USER_GID} -n ${USERNAME} code || true && \
        usermod -u ${USER_UID} -g ${USER_GID} -l ${USERNAME} -m -d /home/${USERNAME} code && \
        chown -R ${USER_UID}:${USER_GID} /nix && \
        chown -R ${USER_UID}:${USER_GID} /home/${USERNAME} && \
        echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/devcontainer; \
    fi

ONBUILD USER ${USERNAME}
