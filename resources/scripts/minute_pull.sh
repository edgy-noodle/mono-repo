#!/bin/bash
. "$HOME"/.keychain/"$HOSTNAME"-sh;
cd ~/mono-repo || return;
/usr/bin/git pull origin main;