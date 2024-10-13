FROM fedora:latest

# Defaults
ARG DEFAULT_USER='jonathan'
ARG GITHUB_USERNAME='jonathan'
ARG GITHUB_EMAIL='celluloid-demon@users.noreply.github.com'

# Install core packages
RUN dnf install -y @core
RUN dnf install -y byobu curl git gh nano pv rsync screen tldr tmux tree passwd wget which
RUN dnf groupinstall -y "Development Tools"
RUN dnf groupinstall -y "Development Libraries"

# Install ansible (full version)
RUN dnf install -y ansible

# Add user
RUN useradd --create-home ${DEFAULT_USER}
RUN echo "${DEFAULT_USER}:password" | chpasswd
RUN usermod -a -G wheel ${DEFAULT_USER}

USER ${DEFAULT_USER}

# Add required directories
RUN mkdir -p ${HOME}/applications

# Merge user files and set permissions
# COPY --chown=${DEFAULT_USER}:${DEFAULT_USER} docker/home/${DEFAULT_USER} /home/${DEFAULT_USER}
# RUN chmod 755 ${XFCE_WRAPPER_DIR}/bin/*

USER ${DEFAULT_USER}

# Configure git
RUN git config --global user.name  "${GITHUB_USERNAME}"
RUN git config --global user.email "${GITHUB_EMAIL}"

# Install shared-config-nix
RUN cd ${HOME}/applications && git clone "https://www.github.com/celluloid-demon/shared-config-nix"
RUN mkdir -p ${HOME}/.bashrc.d
RUN ln -s ${HOME}/applications/shared-config-nix/home/bin ${HOME}/bin
RUN ln -s ${HOME}/applications/shared-config-nix/home/usr ${HOME}/usr
RUN ln -s ${HOME}/applications/shared-config-nix/dot-files/bash_aliases ${HOME}/.bashrc.d/bash_aliases

WORKDIR /home/${DEFAULT_USER}
