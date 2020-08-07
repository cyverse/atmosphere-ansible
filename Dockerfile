from ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install ansible ssh && rm -rf /var/lib/apt/lists/*

ADD ansible /opt/atmosphere-ansible
ADD ansible/ansible.cfg.docker /etc/ansible/ansible.cfg
