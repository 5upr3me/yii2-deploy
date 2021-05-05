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

ssh  -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST chmod +x /usr/local/bin/composer
sh -c "ssh  -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST cd $INPUT_REMOTE_PATH && /usr/local/bin/composer update --no-progress --no-interaction"
echo $'\n' "------ COMPOSER UPDATE ---------" $'\n'
sh -c "ssh  -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST cd $INPUT_REMOTE_PATH && php yii migrate"
echo $'\n' "------ MIGRATION APPLIED  ---------" $'\n'
sh -c "ssh  -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST chown -R www-data:www-data $INPUT_REMOTE_PATH"
sh -c "ssh  -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST chmod 775 -R $INPUT_REMOTE_PATH/web"
sh -c "ssh  -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST chmod 777 -R $INPUT_REMOTE_PATH/runtime"
sh -c "ssh  -t $INPUT_REMOTE_USER@$INPUT_REMOTE_HOST chmod 777 -R $INPUT_REMOTE_PATH/web/assets"


echo $'\n' "------ CONGRATS! DEPLOY SUCCESSFUL!!! ---------" $'\n'
exit 0
