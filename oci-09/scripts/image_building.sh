#!/bin/bash
# Put here all the commands you need to build your custom image
# This example builds Node.js from source
nodejs_version="v11.0.0"
#
sudo yum -y install git python gcc-c++ make
wget "https://nodejs.org/dist/$nodejs_version/node-$nodejs_version.tar.gz"
curl -O "https://nodejs.org/dist/$nodejs_version/SHASUMS256.txt"
grep "node-$nodejs_version.tar.gz" SHASUMS256.txt | sha256sum -c -
rm SHASUMS256.txt
tar xzvf "node-$nodejs_version.tar.gz"
cd "node-$nodejs_version/"
./configure
make -j4
sudo make install
cd ..
rm -rf node-v*
node -e "console.log('Hello from Node.js ' + process.version)"
npm --version
node --version
