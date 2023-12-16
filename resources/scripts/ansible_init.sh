#!/bin/bash
set -eou pipefail

# VARS
REPO=git@github.com:edgy-noodle/mono-repo.git
ANSIBLE_PATH=/home/ansible
VMS=vms.txt
USER=edgy

echo "Creating ansible user..."
if id "ansible" >/dev/null 2>&1; then
  echo "User already exists, skipping..."
else
  useradd -m -s /bin/bash -g sudo ansible
  passwd ansible
fi

echo "Installing pip, pipx, git, sudo and keychain..."
apt update -y
apt install -y python3-pip pipx keychain git sudo
python3 -m pipx ensurepath

echo "Installing ansible-core..."
mkdir -p /etc/bash_completion.d
PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install --include-deps ansible-core
PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install --include-deps jmespath
PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx inject --include-apps ansible-core argcomplete jmespath
activate-global-python-argcomplete

echo "Generating an Ansible key..."
mkdir -p $ANSIBLE_PATH/.ssh ~/.ssh
if [ -f $ANSIBLE_PATH/.ssh/ansible ]; then
  echo "Key already exists, skipping..."
else
  ssh-keygen -t ed25519 -C "ansible ssh" -f $ANSIBLE_PATH/.ssh/ansible -N ""
fi

echo "Copying the key to managed VMs..."
for ip in $(cat ~/$VMS); do
  ssh-copy-id -i $ANSIBLE_PATH/.ssh/ansible "$USER@$ip"
done

echo "Generating a GitHub key..."
if [ -f $ANSIBLE_PATH/.ssh/github ]; then
  echo "Key already exists, skipping..."
else
  ssh-keygen -t ed25519 -C "ansible github" -f $ANSIBLE_PATH/.ssh/github
fi

echo "Here is your GitHub key:"
cat $ANSIBLE_PATH/.ssh/github.pub

# Wait until key is added to GitHub
echo "If running initial setup, add the key to your GitHub account as per the instructions:
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
echo "Once done, press any key to continue..."
read -rs -n 1

echo "Cloning the repository."
if [ -d $ANSIBLE_PATH/mono-repo ]; then
  echo "Directory exists, skipping..."
else
  git clone -c core.sshCommand="/usr/bin/ssh -i $ANSIBLE_PATH/.ssh/github" $REPO $ANSIBLE_PATH/mono-repo
  git config --local core.filemode false
  chown -R ansible $ANSIBLE_PATH/mono-repo $ANSIBLE_PATH/.ssh
fi

echo "Setting repository as default login location..."
if grep -q "# Open mono-repo on login" $ANSIBLE_PATH/.profile; then
  echo "Login location set, skipping..."
else
  cat <<EOF >> $ANSIBLE_PATH/.profile
# Open mono-repo on login
cd ~/mono-repo/ansible
git pull
EOF
fi

echo "Setting up keychain..."
if grep -q "# Login to SSH keys on login" $ANSIBLE_PATH/.profile; then
  echo "Keychain set, skipping..."
else
  cat <<EOF >> $ANSIBLE_PATH/.profile
# Login to SSH keys on login
keychain $ANSIBLE_PATH/.ssh/ansible $ANSIBLE_PATH/.ssh/github
source $ANSIBLE_PATH/.keychain/\${HOSTNAME}-sh
EOF
fi

echo "Setting up a periodic git pull..."
if crontab -u ansible -l 2>>/dev/null | grep -q "./minute_pull.sh"; then
  echo "Job already exists, skipping..."
else
  crontab -u ansible -l | \
    { cat; echo "* * * * * cd ~/mono-repo/resources/scripts/; chmod u+x minute_pull.sh; ./minute_pull.sh"; } \
    | crontab -u ansible -
fi

echo "Switching to ansible user..."
su - ansible