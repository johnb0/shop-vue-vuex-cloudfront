#!/bin/bash 

set -o nounset                              # Treat unset variables as an error

# Config
declare SCRIPT_DIR=$(dirname $(realpath $0))
declare ENV_FILE=$SCRIPT_DIR/.env
FE_HOST_BUILD_DIR=$SCRIPT_DIR/build
FE_REMOTE_DIR=/var/www/fe_app
SSH_ALIAS=centos

# Install dependencies
yarn install

# Run quality checks
bash $SCRIPT_DIR/quality-check.sh

# Build the app
if [[ -e $ENV_FILE ]];
then
  echo 'Building the app...'
  yarn build
else
  echo "$ENV_FILE is not defined. Create it to proceed"
fi;

# Copy build artefact to VM
echo "Copying the artefact to VM..."
scp -Crq $FE_HOST_BUILD_DIR/* $SSH_ALIAS:$FE_REMOTE_DIR
