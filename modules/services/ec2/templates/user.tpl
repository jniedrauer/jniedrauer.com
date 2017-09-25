#cloud-config

users:
  - name: ${name}
    groups: wheel
    ssh-authorized-keys: ${pubkeys}
