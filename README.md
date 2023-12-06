# mono-repo

[![yamllint_gha](https://github.com/edgy-noodle/mono-repo/actions/workflows/yamllint.yml/badge.svg)](https://github.com/edgy-noodle/mono-repo/actions/workflows/yamllint.yml)
[![shellcheck_gha](https://github.com/edgy-noodle/mono-repo/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/edgy-noodle/mono-repo/actions/workflows/shellcheck.yml)
[![sqlreview_gha](https://github.com/edgy-noodle/mono-repo/actions/workflows/sqlreview.yml/badge.svg)](https://github.com/edgy-noodle/mono-repo/actions/workflows/sqlreview.yml)
[![fluxe2e_gha](https://github.com/edgy-noodle/mono-repo/actions/workflows/fluxe2e.yml/badge.svg)](https://github.com/edgy-noodle/mono-repo/actions/workflows/fluxe2e.yml)

One repo to rule them all.  
Ansible-provisioned bare-metal k8s cluster managed by Flux.


## Structure

```struct
.
|-- ansible
|   |-- playbooks
|   `-- roles
|       |-- k8s
|       |   |-- k8s_all
|       |   |-- k8s_cpn
|       |   |-- k8s_flux
|       |   `-- k8s_workers
|       `-- unix
|           |-- vms_init
|           `-- vms_update
|-- flux
|   |-- clusters
|   |   `-- dev
|   |       |-- flux-system
|   |       `-- infra
|   `-- infra
|       |-- cloudflare-tunnel
|       `-- weave-gitops
`-- resources
    |-- gha
    `-- scripts
```

## Usage
### Prerequisites

- a Debian/Ubuntu VM for Ansible Control Node
- Debian/Ubuntu VMs for k8s cluster
- network connectivity and SSH accessibility on all VMs

### Tips

- create a golden image with SSH included and create remaining VMs by import
- customize settings as fit for purpose and rename each VM via `hostnamectl set-hostname`
- add VMs to your hosts file for easy SSH access

### Getting started

1. Fork `mono-repo` to your own account and update the `inventory` file with your managed nodes.
2. SSH into your Ansible Control Node and switch to _root_ user with `su -`.
3. Create a `vms.txt` file containing a space-separated list of your managed node's IPs.
4. Copy the contents of `ansible_init.sh` script found under `resources\scripts` and edit the _USER_ and _REPO_ vars to match your SSH user and fork.
5. Run `chmod u+x ansible_init.sh` to make it executable, then run `./ansible_init.sh` and follow the directions until finished.

> You should now be switched to the newly created `ansible` account.

6. Run `echo "eval $(keychain -q --agents ssh --eval ~/.ssh/ansible ~/.ssh/github)" >> ~/.bashrc; source ~/.bashrc` to set up keychain.
7. Run `git pull` to accept repo fingerprint; needed for the minute pull cronjob to work correctly.
8. Run `ansible-playbook ./playbooks/ansible_init.yml` to initialize Ansible itself. 
9. Run `ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --ask-become-pass ./playbooks/vms_init.yml -e 'ansible-user=<USER>'` to initialize managed nodes. Set `<USER>` to the initial account you created across all VMs.
10. Generate PAT as described [in this guide](https://fluxcd.io/flux/installation/bootstrap/github/#github-personal-account).
11. Run `ansible-playbook ./playbooks/k8s_init.yml -e '<EXTRA_VARS>'` to provision the k8s cluster. Specify the following variables as a space-separated list of _key=value_ pairs to use with Flux bootstrap:
    - `flux_gh_owner` - repo owner username (`--owner`)
    - `flux_gh_repo` - repo name (`--repository`)
    - `flux_gh_cluster` - cluster path (`--path`)
    - `flux_gh_token` - PAT generated in previous step


## Useful links

- [Ansible Docs](https://docs.ansible.com/)
- [k8s Docs](https://kubernetes.io/docs/concepts/)
  - [Kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
- [Flux Docs](https://fluxcd.io/flux/)
  - [Flux Bootstrap](https://fluxcd.io/flux/installation/bootstrap/github/)
- [Helm Docs](https://helm.sh/docs/)