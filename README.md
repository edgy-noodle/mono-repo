# mono-repo
One repo to rule them all.  
Ansible-provisioned k8s cluster managed by Flux.

---

## Structure


---

## Usage
### Prerequisites

- a Debian/Ubuntu VM for Ansible Control Node
- Debian/Ubuntu VMs for k8s cluster
- network connectivity and SSH on all VMs

### Tips

- create a golden image with SSH included and create all VMs by import
- customize settings as fit for purpose and rename each VM via `hostnamectl set-hostname`
- add VMs to your hosts file for easy SSH access

### Get started
1. Fork `mono-repo` to your own account.
2. SSH into your Ansible Control Node and switch to _root_ user with `su -`.
3. Create a `vms.txt` file containing a space-separated list of your managed node's IPs.
4. Copy the `ansible_init.sh` script found under `resources\scripts` and edit the _USER_ and _REPO_ vars to match your SSH user.
5. Run `chmod u+x ansible_init.sh` to make script executable.
6. Run `./ansible_init.sh` and follow the directions until finished.
7. Run `echo "eval $(keychain -q --agents ssh --eval ~/.ssh/ansible ~/.ssh/github)" >> ~/.bashrc` to set up keychain.
8. Run `git pull` to add repo fingerprint.


## Useful links