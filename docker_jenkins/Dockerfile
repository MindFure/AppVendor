FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
    apt-get install -y ansible git openssh-client sshpass && \
    apt-get clean

USER jenkins