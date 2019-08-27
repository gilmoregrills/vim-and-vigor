# Path to the bash it configuration
export BASH_IT="/Users/robinyonge/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='robin'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# GOLANG stuff:
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

#GNU sed/find etc
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"


# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

function awsssh(){
  ssh $(aws ec2 describe-instances --region $1 --instance-id $2 --query 'Reservations[].Instances[].PrivateIpAddress' | tail -n 2 | head -n 1 | awk -F\" '{print $2}')
};

function awsip(){
  aws ec2 describe-instances --region $1 --instance-id $2 --query 'Reservations[].Instances[].PrivateIpAddress' | tail -n 2 | head -n 1 | awk -F\" '{print $2}'
};

function gAddKey() {
  eval "$(ssh-agent)"
  ssh-add ~/.ssh/id_rsa_github ~/.ssh/id_rsa_tractable
};

# pass a profile name and it will export the keys
function set_aws_keys() {
  id=(`aws configure get ${1}.aws_access_key_id`);
  secret=(`aws configure get ${1}.aws_secret_access_key`);
  export AWS_ACCESS_KEY_ID=$id;
  export AWS_SECRET_ACCESS_KEY=$secret;
};

function set_aws_pro(){
  if [ -z "$1" ]
    then
      PS3='Select aws profile to use: '
      vars=(`cat ~/.aws/credentials | grep '\[*\]'| egrep -o '[^][]+'`)
      echo "Execute \"set_aws_pro profile\" to switch account";
      select opt in "${vars[@]}" ""Quit
        do
          if [ "$opt" = "Quit" ]; then
            echo done
            break
          elif [[ "${vars[*]}" == *"$opt"* ]]; then
            export AWS_DEFAULT_PROFILE=$opt;
            set_aws_keys $opt;
            aws iam get-user;
            aws configure list;
            break
          else
           clear
           echo bad option
          fi
      done
    else
      export AWS_DEFAULT_PROFILE=$1;
      echo "Current profile is:";
      aws configure list;
  fi
};

function unset_aws_creds(){
  unset AWS_SESSION_TOKEN
  unset AWS_SECURITY_TOKEN
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_ACCESS_KEY_ID
  unset AWS_DEFAULT_PROFILE
  unset ASSUMED_ROLE
};

# Usage:
# get_aws_mfa_token <code> <profile-name>
# profile name is optional and it will default to "default"
function aws_mfa_login(){
    unset_aws_creds
    if [ -z "$1" ]
        then
            echo "Please provide a token from your MFA device!";
            return 1;
    fi
    if [ -z "$2" ]
        then
						echo "Profile not specified, using 'default'";
            profile="default";
        else
            profile="$2";
    fi
    mfaSerial=(`aws iam list-mfa-devices | jq -r .MFADevices[0].SerialNumber`); # get the ARN of the mfa device
    echo "Fetching temporary login credentials for `aws configure get ${profile}.aws_access_key_id`";
    aws sts get-session-token --serial-number ${mfaSerial} --token-code ${1} --profile ${profile} > sts_output.json; # generates temporary creds using device and code 
		if [ $? == 0 ]
			  then
            echo "Login Successful";
		fi
    access_key=$(jq '.Credentials.AccessKeyId' -r sts_output.json);
    secret=$(jq '.Credentials.SecretAccessKey' -r sts_output.json);
		session_token=$(jq '.Credentials.SessionToken' -r sts_output.json);
    export AWS_ACCESS_KEY_ID=$access_key
    export AWS_SECRET_ACCESS_KEY=$secret
    export AWS_SESSION_TOKEN=$session_token
		echo "Credentials Exported";
    rm sts_output.json
};

# set_aws_assumerole uses assume-role script, brew install assume-role
function set_aws_assumerole(){
  if [ -z "$1" ]
    then
      PS3='Select aws assume role profile to use: ';
      vars=($(cat ~/.aws/config | awk -F'[][]' '{print $2}' | grep -oP 'assumerole-\K.*'));
      echo "Execute \"set_aws_assumerole\" to assume another role";
      select opt in "${vars[@]}" ""Quit
        do
          if [ "$opt" = "Quit" ]; then
            echo done;
            break;
          elif [[ "${vars[*]}" == *"$opt"* ]]; then
            role="assumerole-${opt}";
            echo "Assuming role named: ${role}";
            eval $(assume-role ${role});
            account_aliases=$(aws iam list-account-aliases --query 'AccountAliases' --output text);
            account_id=$(aws sts get-caller-identity --query 'Account' --output text);
            echo "Assumed role in AccountID: ${account_id} AccountAlias: ${account_aliases}";
            break;
          else
           clear;
           echo bad option;
          fi
      done
    else
      echo "Assuming role named: ${1}";
      eval $(assume-role ${1});
      account_aliases=$(aws iam list-account-aliases --query 'AccountAliases' --output text);
      account_id=$(aws sts get-caller-identity --query 'Account' --output text);
      echo "Assumed role in AccountID: ${account_id} AccountAlias: ${account_aliases}";
  fi
};

function chrome() {
  local site=""
  if [[ -f "$(pwd)/$1" ]]; then
    site="$(pwd)/$1"
  elif [[ "$1" =~ "^http" ]]; then
    site="$1"
  else
    site="http://$1"
  fi
  /usr/bin/open -a "/Applications/Google Chrome.app" "$site";
};

defaults write com.apple.screencapture location /Users/robinyonge/Dropbox/screenshots

source /Users/robinyonge/.bash_secrets

# Aliases:
# General:
alias reload="bash-it reload"
alias rr="reload"
alias shebang='echo "#!/usr/bin/env bash"'
alias typora="open -a typora"
alias watch="watch "
alias vim="nvim"
alias sed="gsed"
alias idGroups="id -a | sed 's|,|\n|g'"

# Git:
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gb="git branch"
alias gch="git checkout"
alias gResetMaster="git fetch origin && git reset --hard origin/master"

# Terraform
alias tf="terraform"
alias tf11="/usr/local/opt/terraform@0.11/bin/terraform"
alias terraform@0.11="/usr/local/opt/terraform@0.11/bin/terraform"

# Kubernetes
alias k="kubectl"
alias kuebctl="kubectl" # most common typo lmao
alias kontext="kubectl config use-context" # switch context and print namespaces to test
alias kns="kubectl get ns"

# Docker
alias d="docker"

# thefuck
eval "$(thefuck --alias)"

# Easier navigation: .., ..., ...., ....., ~ and -
alias ls="ls -G"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"                  # Go to previous dir with -
alias cd.='cd $(readlink -f .)'    # Go to real dir (i.e. if current dir is linked)

# Network
alias ipl="echo \"private ip:\"; ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1';echo \"public ip:\"; curl whatismyip.akamai.com; echo"
alias pcurl='curl --silent -o /dev/null -v -H "Pragma: akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no"'

# OSX
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# Load Bash It
source "$BASH_IT"/bash_it.sh
