#!/bin/bash
# Put here all the commands you need to build your custom image
# This example installs Node.js
#
sudo yum -y install nodejs
node -e "console.log('Hello from Node.js ' + process.version)"
npm --version
node --version
