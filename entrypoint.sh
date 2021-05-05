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

# ssh -i /root/.ssh/id_rsa -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST "sudo chown -R www-data:www-data $INPUT_REMOTE_PATH"
# ssh -i /root/.ssh/id_rsa -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST "sudo chmod 775 -R $INPUT_REMOTE_PATH/web"
# ssh -i /root/.ssh/id_rsa -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST "sudo chmod 777 -R $INPUT_REMOTE_PATH/runtime"
# ssh -i /root/.ssh/id_rsa -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST "sudo chmod 777 -R $INPUT_REMOTE_PATH/web/assets"
sh -c "ssh -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST touch  $INPUT_REMOTE_PATH/test "

echo $'\n' "------ CONGRATS! DEPLOY SUCCESSFUL!!! ---------" $'\n'
exit 0
