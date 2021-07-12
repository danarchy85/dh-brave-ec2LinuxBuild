#!/bin/bash
set -x
cd ${HOME}

until [[ -x $(which npm) ]]; do
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y build-essential gnome-keyring python-setuptools npm
done

set -e
git clone https://github.com/brave/brave-browser.git
cd ~/brave-browser

npm install
npm run init

./src/build/install-build-deps.sh

echo "Running 'npm run create_dist Release' in screen 'brave-build'..."
screen -S brave-build -L -Logfile /tmp/brave-build.log -d -m npm run create_dist Release
