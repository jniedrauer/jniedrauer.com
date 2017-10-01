#cloud-config

repo_update: true
repo_upgrade: all
hostname: "${hostname}"
fqdn: "${hostname}.internal"
manage_etc_hosts: true

packages: ${packages}

runcmd:
  - sed -i '/^Defaults.*requiretty$/d' /etc/sudoers
