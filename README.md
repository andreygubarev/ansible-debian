# `andreygubarev.debian`

Ansible collection for Debian

## Installation

To install this collection use the `ansible-galaxy` command-line tool:

```sh
ansible-galaxy collection install andreygubarev.debian
```

## Roles `andreygubarev.debian.tmproot_mount` and `andreygubarev.debian.tmproot_unmount`

Role `tmproot_mount` mounts tmpfs to root partition and moves root to tmpfs. Role `tmproot_unmount` unmounts tmpfs and moves root back to root partition. Mounting temporary root partition is required for:
- modifying root partition (including resizing)
- creating separate partitions for `/var`, `/home`, `/tmp` folders

`tmproot_*` roles implement the following logic:
1.1 Mount tmpfs to `/mnt/tmproot` and performs `debootstrap` into it
1.2 Copies SSH keys from root partition to `/mnt/tmproot`
1.3 Stops all running services
1.4 Pivot root and temporary root
1.5 Starts SSH server
1.6 Unmounts root partition
2.1 Mounts root partition to `/mnt/root`
2.2 Pivot temporary root and root
2.3 Starts all services

Usage example:
```yaml
- name: Temporary root
  hosts: all
  become: true
  roles:
    - role: tmproot_mount
    # do something with root partition
    - role: tmproot_unmount
      vars:
        tmproot_partition: /dev/vda2
```

# Reference

- [Ansible Galaxy](https://galaxy.ansible.com/andreygubarev/debian) - Find more information and download the collection.
- [Source Code](https://github.com/andreygubarev/ansible-debian) - Access the collection's source code on Github.
