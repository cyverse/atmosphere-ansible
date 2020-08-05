from ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install ansible ssh

ADD ansible /opt/atmosphere-ansible
ADD ansible/ansible.cfg.docker /etc/ansible/ansible.cfg
