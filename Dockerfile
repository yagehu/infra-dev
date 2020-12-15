FROM debian:buster-slim

WORKDIR /root

COPY .terragrunt-version .
COPY .terraform-version .
COPY .zshrc .
COPY docker-entrypoint.sh .

RUN apt-get update && apt-get install --assume-yes \
    awscli \
    curl \
    git-all \
    gnupg2 \
    lsb-release \
    software-properties-common \
    unzip \
    zsh

SHELL ["/bin/zsh", "-c"]

# Install tgenv for managing Terragrunt versions.
RUN git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv
RUN source ~/.zshrc && tgenv install

# Install tfenv for managing Terraform versions.
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv
RUN source ~/.zshrc && tfenv install

# Install Packer.
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository \
    "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update && apt-get install --assume-yes packer

# Install Ansible.
RUN apt-add-repository \
    "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main"
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
RUN apt-get update && apt-get install --assume-yes ansible

ENTRYPOINT ["/root/docker-entrypoint.sh"]
