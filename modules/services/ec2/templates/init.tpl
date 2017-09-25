#cloud-config
repo_update: true
repo_upgrade: all
hostname: "${hostname}"
fqdn "${hostname}.internal"
manage_etc_hosts: true

packages:
  - python35
  - python35-pip

runcmd:
  - sed -i '/^Defaults.*requiretty$/d' /etc/sudoers
  - sh -c "echo -e '\n%wheel\tALL=(ALL)\tNOPASSWD: ALL' >>/etc/sudoers"
