#cloud-config

users:
  - name: ${name}
    groups: wheel
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh-authorized-keys: ${pubkeys}
