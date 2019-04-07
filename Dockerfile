FROM centos:7

COPY ansible-release.repo /etc/yum.repos.d/

RUN yum clean all && yum makecache; \
    yum -y groupinstall "Minimal Install"; \
    yum -y install python; \
    yum -y install openssh-server; \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key; \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key; \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key; \
    yum -y install ansible

COPY id_rsa.pub /tmp/

WORKDIR /root

RUN mkdir .ssh; \
    ssh-keygen -t rsa -f .ssh/id_rsa; \
    touch .ssh/authorized_keys; \
    echo $(cat /tmp/id_rsa.pub) >> .ssh/authorized_keys; \
    rm -f /tmp/id_rsa.pub; \
    mkdir ansible_playbooks; \
    chown root:root ansible_playbooks; \
    chmod 700 ansible_playbooks

EXPOSE 22 80 443

CMD ["/usr/sbin/sshd", "-D", "-p", "22"]
