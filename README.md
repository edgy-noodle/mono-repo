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
|       |   |-- k8s_vault
|       |   |-- k8s_vault_add
|       |   `-- k8s_workers
|       `-- unix
|           |-- nfs_init
|           |-- vms_init
|           `-- vms_update
|-- flux
|   |-- clusters
|   |   `-- dev
|   |       |-- flux-system
|   |       `-- infra
|   `-- infra
|       |-- cloudflare-tunnel
|       |-- consul
|       |-- grafana
|       |-- metrics-server
|       |-- postgresql
|       |-- prometheus
|       |-- secrets-store
|       |   |-- secrets-store-csi-driver
|       |   `-- vault-csi-provider
|       |-- sources
|       |-- storage
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

##### VMs

1. Fork `mono-repo` and update the `inventory` file with your managed nodes.
2. SSH into your Ansible Control Node and switch to _root_ user with `su -`.
3. Create a `vms.txt` file containing a space-separated list of your managed node's IPs.
4. Copy the contents of `ansible_init.sh` script found under `resources\scripts` and edit the _USER_ and _REPO_ vars to match your SSH user and fork.
5. Run `chmod u+x ansible_init.sh` to make it executable, then run `./ansible_init.sh` and follow the directions until finished.

> You should now be switched to the newly created `ansible` account.  
> If you need to add another VM in the future, simply switch to _root_, add it to `vms.txt` and run the script again.

##### Ansible

1. Generate a secure password and save it under `~/mono-repo/ansible/.vault-password`.
2. Run `ansible-playbook ./playbooks/ansible_init.yml` to initialize Ansible itself. 
3. Run `ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --ask-become-pass ./playbooks/vms_init.yml -u <USER>` to initialize managed nodes. Set `<USER>` to the initial account you created across all VMs.

> Remaining playbooks can now be executed with `ansible-playbook ./playbooks/<PLAYBOOK_NAME> <OPTIONS>`.  
> Extra variables can be added with `-e ''` option as a space-separated list of _key=value_ pairs between the brackets.

##### K8s and Flux

1. Generate PAT as described [in this guide](https://fluxcd.io/flux/installation/bootstrap/github/#github-personal-account).
2. Run `k8s_init.yml` playbook with the following variables for Flux bootstrap:
   - `flux_gh_owner` - repo owner username (`--owner`)
   - `flux_gh_repo` - repo name (`--repository`)
   - `flux_gh_cluster` - cluster path (`--path`)
   - `flux_gh_token` - PAT generated in previous step

> The cluster is now ready and can be interacted with from any of the k8s nodes. You can easily ssh through the ansible user on the Ansible Controle Node.

##### HashiCorp Vault

1. Create/login to your AWS root account and under _IAM_ create a policy with the following permissions for _KMS_ service:
   - _Read/DescribeKey_
   - _Write/Decrypt_
2. Create a user and assign it to the policy. In _Users_ view under _IAM_, create an access key.
3. Under _KMS_, create a new key with the default config and name it `vault`. Pay attention to the region.
4. Run `k8s_init.yml` playbook with `--tags k8s_vault` and the following variables:
   - `vault_aws_access_key_id` - generated in _Step 2_
   - `vault_aws_secret_access_key` - generated in _Step 2_
   - `vault_aws_region` - chosen in _Step 3_
   - `vault_aws_kms_key_id` - generated in _Step 3_

##### Adding secrets

1. Run `k8s_vault_add.yml` playbook with the following variables:
   - `vault_secret_name`
   - `vault_secret_data` - a JSON dict object containing _"key":"value"_ pairs


## Useful links

- [Ansible Docs](https://docs.ansible.com/)
- [k8s Docs](https://kubernetes.io/docs/concepts/)
  - [Kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
- [Flux Docs](https://fluxcd.io/flux/)
  - [Flux Bootstrap](https://fluxcd.io/flux/installation/bootstrap/github/)
- [Helm Docs](https://helm.sh/docs/)
- [AWS Docs](https://docs.aws.amazon.com/)
  - [AWS IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started.html)
  - [AWS KMS](https://docs.aws.amazon.com/kms/latest/developerguide/overview.html)