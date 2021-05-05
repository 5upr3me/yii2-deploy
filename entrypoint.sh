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

ssh -p $INPUT_REMOTE_PORT  -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST "cd $INPUT_REMOTE_PATH; composer install --prefer-dist --no-interaction --no-progress --optimize-autoloader --ansi"

ssh  -p $INPUT_REMOTE_PORT -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST "cd $INPUT_REMOTE_PATH; php yii migrate"
sh -c "ssh -p $INPUT_REMOTE_PORT -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST chown -R www-data:www-data $INPUT_REMOTE_PATH"
sh -c "ssh  -p $INPUT_REMOTE_PORT -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST chmod 775 -R $INPUT_REMOTE_PATH"



echo $'\n' "------ CONGRATS! DEPLOY SUCCESSFUL!!! ---------" $'\n'
exit 0
