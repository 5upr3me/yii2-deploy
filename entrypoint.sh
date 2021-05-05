#!/bin/sh

# Start the SSH agent and load key.
source agent-start "$GITHUB_ACTION"
echo "$INPUT_REMOTE_KEY" | agent-add

# Add strict errors.
set -eu

# Variables.
SWITCHES="$INPUT_SWITCHES"
RSH="ssh -o StrictHostKeyChecking=no -p $INPUT_REMOTE_PORT $INPUT_RSH"
LOCAL_PATH="$GITHUB_WORKSPACE/$INPUT_PATH"
DSN="$INPUT_REMOTE_USER@$INPUT_REMOTE_HOST"

# Deploy.
sh -c "rsync $SWITCHES -e '$RSH' $LOCAL_PATH $DSN:$INPUT_REMOTE_PATH"

ssh -i /root/.ssh/id_rsa -t $1@$2 "sudo chown -R $4:$4 $3"
ssh -i /root/.ssh/id_rsa -t $1@$2 "sudo chmod 775 -R $3/web"
ssh -i /root/.ssh/id_rsa -t $1@$2 "sudo chmod 777 -R $3/runtime"
ssh -i /root/.ssh/id_rsa -t $1@$2 "sudo chmod 777 -R $3/web/assets"

echo $'\n' "------ CONGRATS! DEPLOY SUCCESSFUL!!! ---------" $'\n'
exit 0
