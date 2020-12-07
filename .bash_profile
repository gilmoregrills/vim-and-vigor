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

# load zoxide 
eval "$(zoxide init bash)"

#
# Functions:
#

function awsssh(){
  ssh $(aws ec2 describe-instances --region $1 --instance-id $2 --query 'Reservations[].Instances[].PrivateIpAddress' | tail -n 2 | head -n 1 | awk -F\" '{print $2}')
};

function awsip(){
  aws ec2 describe-instances --region $1 --instance-id $2 --query 'Reservations[].Instances[].PrivateIpAddress' | tail -n 2 | head -n 1 | awk -F\" '{print $2}'
};

function gAddKey() {
  eval "$(ssh-agent)"
  ssh-add ~/.ssh/id_rsa_github ~/.ssh/id_rsa_tractable ~/.ssh/liebkind-root
};

function unset_aws_creds(){
  unset AWS_SESSION_TOKEN
  unset AWS_SECURITY_TOKEN
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_ACCESS_KEY_ID
  unset AWS_DEFAULT_PROFILE
  unset ASSUMED_ROLE
  unset AWS_PROFILE
  unset SAML2AWS_PROFILE
  unset AWS_CREDENTIAL_EXPIRATION
};

# pass a profile name and it will export the keys
function set_aws_keys() {
  id=(`aws configure get ${1}.aws_access_key_id`);
  secret=(`aws configure get ${1}.aws_secret_access_key`);
  session=(`aws configure get ${1}.aws_session_token`);
  security=(`aws configure get ${1}.aws_security_token`);
  export AWS_ACCESS_KEY_ID=$id;
  export AWS_SECRET_ACCESS_KEY=$secret;
  export AWS_SESSION_TOKEN=$session;
  export AWS_SECURITY_TOKEN=$security;
  export AWS_DEFAULT_PROFILE=${1};
  export AWS_PROFILE=${1};
  export SAML2AWS_PROFILE=${1};
};

function iterm2_set_user_vars() {
  iterm2_set_user_var aws_profile "$AWS_DEFAULT_PROFILE"
};

function awsSetProfile(){
  unset_aws_creds
  if [ -z "$1" ]
    then
      PS3='Select aws profile to use: '
      #TODO: make the menu searchable/selectable with arrow keys
      vars=(`cat ~/.aws/credentials | grep '\[*\]'| egrep -o '[^][]+'`)
      echo "Execute \"awsSetProfile profile\" to switch account";
      select opt in "${vars[@]}" ""Quit
        do
          if [ "$opt" = "Quit" ]; then
            echo done
            break
          elif [[ "${vars[*]}" == *"$opt"* ]]; then
            iterm2_set_user_vars;
            set_aws_keys $opt;
            #TODO: add nicer output here from get-user and get-caller-identity
            aws configure list;
            break
          else
           clear
           echo bad option
          fi
      done
    else
      export AWS_DEFAULT_PROFILE=$1;
      iterm2_set_user_vars;
      echo "Current profile is:";
      aws configure list;
  fi
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

#
# Aliases:
#

# General:
alias reload="bash-it reload"
alias rr="reload"
alias shebang='echo "#!/usr/bin/env bash"'
alias typora="open -a typora"
alias watch="watch "
alias vim="nvim"
alias sed="gsed"
alias cssh="csshx"
alias idGroups="id -a | sed 's|,|\n|g'"
alias weatherAtHome="curl wttr.in/Stepney+Green+London"
alias weather="curl wttr.in"

# Git:
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gb="git branch"
alias gch="git checkout"
alias gchm="git checkout master && git fetch"
alias gpm="git pull origin master"
alias gresetm="git fetch origin && git reset --hard origin/master"
alias gPruneBranches="git for-each-ref --format '%(refname:short)' refs/heads | grep -v master | xargs git branch -D"

# Terraform
alias tf="terraform"
alias tf11="/usr/local/opt/terraform@0.11/bin/terraform"
alias terraform@0.11="/usr/local/opt/terraform@0.11/bin/terraform"
alias tf-fmt="terraform fmt -recursive ."

# AWS etc
alias awsProdSamlLogin="saml2aws login --profile=tractableai --idp-account=tractableai && saml2aws script --profile tractableai"
alias awsProdEUSamlLogin="saml2aws login --profile=tractableai-prod-euce1 --idp-account=tractableai-prod-euce1 && saml2aws script --profile tractableai-prod-euce1"
alias awsProdUSSamlLogin="saml2aws login --profile=tractableai-prod-use1 --idp-account=tractableai-prod-use1 && saml2aws script --profile tractableai-prod-use1"
alias awsProdJPSamlLogin="saml2aws login --profile=tractableai-prod-apne1 --idp-account=tractableai-prod-apne1 && saml2aws script --profile tractableai-prod-apne1"
alias awsSharedSamlLogin="saml2aws login --profile=tractableai-shared --idp-account=tractableai-shared && saml2aws script --profile tractableai-shared"
alias awsMasterSamlLogin="saml2aws login --profile=tractableai-master --idp-account=tractableai-master && saml2aws script --profile tractableai-master"

# Kubernetes
alias k="kubectl"
alias kuebctl="kubectl" # most common typo lmao
alias kns="kubectl get ns"
alias kgp="kubectl get pods"
alias kgpa="kubectl get pods --all-namespaces"
alias kak="kubectl apply -k"
alias kaf="kubectl apply -f"
alias kb="kustomize build"
export MINIKUBE_IN_STYLE=1
export KUBE_EDITOR=nvim

alias eksDevSetup="aws eks update-kubeconfig --region=eu-west-1 --name=k8s-dev --alias=dev --profile=tractableai"
alias eksIntegSetup="aws eks update-kubeconfig --region=eu-west-2 --name=k8s-staging-eu --alias=staging-eu --profile=tractableai"
alias eksProdEUSetup="aws eks update-kubeconfig --region=eu-central-1 --name=k8s-prod-eu --alias=prod-eu --profile=tractableai-prod-euce1"
alias eksProdUSSetup="aws eks update-kubeconfig --region=us-east-1 --name=k8s-prod-us --alias=prod-us --profile=tractableai-prod-use1"
alias eksProdJPSetup="aws eks update-kubeconfig --region=ap-northeast-1 --name=k8s-prod-jp --alias=prod-jp --profile=tractableai-prod-apne1"

# Docker
alias d="docker"
alias dockerKillZombies="docker ps | grep hours | awk '{print $1}' | xargs docker kill"

function dockerRemote() {
  export DOCKER_HOST=ssh://ec2-user@10.5.67.80
  eval "$(ssh-agent)"
  ssh-add ~/.ssh/mesos_integ-eu-west-2
};

function dockerLocal() {
  unset DOCKER_HOST
};

# Easier navigation: .., ..., ...., ....., ~ and -
# alias cd="z"
# alias cdi="zi"
# alias cdq="zq"
# alias cda="za"
# alias cdr="zr"
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

alias gitTempShort='git checkout master && git pull origin master && git checkout -b INFRA-1566 && git add Jenkinsfile && git commit -m "add if-jenkins2 check" && git push origin INFRA-1566'

# misc
alias isabelle='curl https://pastebin.com/raw/1qRgMXn5'

# jira
alias jls='jira ls -a robin.yonge'

#
# startup script:
#

# write screenshots to dropbox please
defaults write com.apple.screencapture location /Users/robinyonge/Dropbox/screenshots
# remap the weird +- key next to 1 to be escape
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000029}]}'
# ssh-add keys for git
gAddKey
# load commonly-used secrets as envvars
source /Users/robinyonge/.bash_secrets

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

eval "$(jira --completion-script-bash)"

# PATH garbage

export PATH="$HOME/.poetry/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=$PATH:/Users/robinyonge/code/git/tractable/cli-tools/bin
export PATH=$PATH:/Users/robinyonge/.kafka/current/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Load Bash It
source "$BASH_IT"/bash_it.sh

export PATH="/usr/local/opt/terraform@0.12/bin:$PATH"
