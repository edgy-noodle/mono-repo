#!/bin/bash
set -eou pipefail

. "$HOME"/.keychain/"$HOSTNAME"-sh;
cd ~/mono-repo || return;
/usr/bin/git pull;