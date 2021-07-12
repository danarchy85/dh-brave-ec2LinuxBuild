#!/bin/bash
set -exo pipefail

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y build-essential gnome-keyring python-setuptools npm

git clone https://github.com/brave/brave-browser.git
cd ~/brave-browser

npm install
npm run init

./src/build/install-build-deps.sh

npm run create_dist Release
