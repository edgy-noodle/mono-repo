#!/bin/bash
#set -eou pipefail

# VARS
REPO=git@github.com:edgy-noodle/mono-repo.git
ANSIBLE_PATH=/home/ansible
VMS=vms.txt
USER=edgy

echo "Creating ansible user..."
useradd -m -s /bin/bash -g sudo ansible
passwd ansible

echo "Installing pip, pipx and keychain..."
apt update -y
apt install -y python3-pip pipx keychain git sudo
python3 -m pipx ensurepath

echo "Installing ansible-core..."
mkdir /etc/bash_completion.d
PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install --include-deps ansible-core
PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx inject --include-apps ansible-core argcomplete
activate-global-python-argcomplete

echo "Generating an Ansible key..."
mkdir -p $ANSIBLE_PATH/.ssh ~/.ssh
ssh-keygen -t ed25519 -C "ansible ssh" -f $ANSIBLE_PATH/.ssh/ansible -N ""

echo "Copying the key to managed VMs..."
for ip in $(cat ~/$VMS); do
  ssh-copy-id -i $ANSIBLE_PATH/.ssh/ansible "$USER@$ip"
done

echo "Generating a GitHub key..."yes
ssh-keygen -t ed25519 -C "ansible github" -f $ANSIBLE_PATH/.ssh/github

echo "Here is your GitHub key:"
cat $ANSIBLE_PATH/.ssh/github.pub

# Wait until key is added to GitHub
echo "Add the key to your GitHub account as per the instructions:
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
echo "Once done, press any key to continue..."
read -rs -n 1

echo "Cloning the repository."
git clone -c core.sshCommand="/usr/bin/ssh -i $ANSIBLE_PATH/.ssh/github" $REPO $ANSIBLE_PATH/mono-repo
git config --local core.filemode false
chown -R ansible $ANSIBLE_PATH/mono-repo $ANSIBLE_PATH/.ssh

echo "Setting repository as default login location..."
cat << EOF >> $ANSIBLE_PATH/.profile
# Open mono-repo on login
cd ~/mono-repo/ansible
EOF

echo "Setting up a periodic git pull..."
crontab -u ansible -l | \
  { cat; echo "* * * * * cd ~/mono-repo/resources/scripts/; chmod u+x minute_pull.sh; ./minute_pull.sh"; } \
  | crontab -u ansible -

echo "Switching to ansible user..."
su - ansible