#!/bin/bash
# VARS
ANSIBLE_VER=2.1
PIP_VER=23.0.1
PIPX_VER=1.1.0
REPO=git@github.com:edgy-noodle/mono-repo.git
VMS=~/vms.txt

echo "Installing pip, pipx and keychain..."
sudo apt install -y python3-pip=$PIP_VER pipx=$PIPX_VER keychain
python3 -m pipx ensurepath
eval "$(register-python-argcomplete pipx)"

echo "Installing ansible-core..."
pipx install --include-deps ansible-core==$ANSIBLE_VER
pipx inject --include-apps ansible argcomplete
activate-global-python-argcomplete --user

echo "Generating an Ansible key..."
ssh-keygen -t ed25519 -C "ansible ssh" -f ~/.ssh/ansible -N ""

echo "Copying the key to managed VMs..."
for ip in $(cat $VMS); do
  ssh-copy-id -i ~/.ssh/ansible "$ip"
done

echo "Generating a GitHub key..."
ssh-keygen -t github -C "ansible github" -f ~/.ssh/github

echo "Here is your GitHub key:"
cat ~/.ssh/id_ed25519

# Wait until key is added to GitHub
echo "Add the key to your GitHub account as per the instructions:
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
echo "Once done, press any key to continue..."
read -rs -n 1

echo "Cloning the repository."
git clone $REPO

echo "Setting repository as default login location..."
cat << EOF >> ~/.profile
# Open mono-repo on login
cd ~/mono-repo/ansible
EOF

echo "Setting up keychain..."
echo "eval $(keychain -q --agents ssh --eval ansible github)" >> ~/.bashrc

echo "Setting up a periodic git pull..."
crontab -l | { cat; echo "* * * * * ~/mono-repo/resources/scripts/minute_pull.sh"; } | crontab -

echo "Reloading bash profile..."
source ~/.bashrc

echo "Opening the ansible directory..."
cd ~/mono-repo/ansible || return

echo "All done!"