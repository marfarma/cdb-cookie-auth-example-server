#!/usr/local/bin/bash
source ./env.sh
terraform destroy -var do_token=$DO_TOKEN -var size=2gb -var ssh_keys=$SSH_KEY_ID -var key_file=$SSH_KEY_PATH
