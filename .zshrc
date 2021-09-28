# load zoxide 
eval "$(zoxide init zsh)"

#
# Functions:
#

function awsssh(){
  ssh $(aws ec2 describe-instances --region $1 --instance-id $2 --query 'Reservations[].Instances[].PrivateIpAddress' | tail -n 2 | head -n 1 | awk -F\" '{print $2}')
};

function awsip(){
  aws ec2 describe-instances --region $1 --instance-id $2 --query 'Reservations[].Instances[].PrivateIpAddress' | tail -n 2 | head -n 1 | awk -F\" '{print $2}'
};

function create-state-lock(){
  aws dynamodb create-table --region eu-west-2 --profile tractableai-shared --table-name $1 --billing-mode PAY_PER_REQUEST --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH
};

function gAddKey() {
  eval "$(ssh-agent)"
  ssh-add ~/.ssh/id_rsa_github ~/.ssh/id_rsa_tractable ~/.ssh/liebkind-root
};

function iterm2_set_user_vars() {
  iterm2_set_user_var aws_profile "$AWS_DEFAULT_PROFILE"
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
alias find="gfind"

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
alias tf-fmt="terraform fmt -recursive ."

# AWS etc
alias awsProdSamlLogin="saml2aws login --profile=tractableai --idp-account=tractableai && saml2aws script --profile tractableai"
alias awsProdEUSamlLogin="saml2aws login --profile=tractableai-prod-euce1 --idp-account=tractableai-prod-euce1 && saml2aws script --profile tractableai-prod-euce1"
alias awsProdUSSamlLogin="saml2aws login --profile=tractableai-prod-use1 --idp-account=tractableai-prod-use1 && saml2aws script --profile tractableai-prod-use1"
alias awsProdJPSamlLogin="saml2aws login --profile=tractableai-prod-apne1 --idp-account=tractableai-prod-apne1 && saml2aws script --profile tractableai-prod-apne1"
alias awsSharedSamlLogin="saml2aws login --profile=tractableai-shared --idp-account=tractableai-shared && saml2aws script --profile tractableai-shared"
alias awsMasterSamlLogin="saml2aws login --profile=tractableai-master --idp-account=tractableai-master && saml2aws script --profile tractableai-master"
alias awsSandboxSamlLogin="saml2aws login --profile=tractableai-sandbox --idp-account=tractableai-sandbox && saml2aws script --profile tractableai-sandbox"
alias awsResearchSamlLogin="saml2aws login --profile=tractableai-research --idp-account=tractableai-research && saml2aws script --profile tractableai-research"
alias awsResearchRoleSharedSamlLogin="saml2aws login --profile=tractableai-shared-research --idp-account=tractableai-shared-research && saml2aws script --profile tractableai-shared-research"

# Kubernetes
alias kuebctl="kubectl" # most common typo lmao
alias kns="kubectl get ns"
alias kgp="kubectl get pods"
export MINIKUBE_IN_STYLE=1
export KUBE_EDITOR=nvim

# Docker
alias d="docker"
alias dockerKillZombies="docker ps | grep hours | awk '{print $1}' | xargs docker kill"
alias dockerHardReset="docker ps -q | xargs -L1 docker stop && test -z \"$(docker ps -q 2>/dev/null)\" && osascript -e 'quit app \"Docker\"' && open --background -a Docker"

function dockerRemote() {
  export DOCKER_HOST=ssh://ubuntu@10.12.3.178
  eval "$(ssh-agent)"
  ssh-add ~/.ssh/est-cr-us.pem
};

function dockerLocal() {
  unset DOCKER_HOST
};

# Easier navigation: .., ..., ...., ....., ~ and -
alias ls="ls -G"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"                  # Go to previous dir with -
alias cd.='cd $(readlink -f .)'    # Go to real dir (i.e. if current dir is linked)

# OSX
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# misc
alias isabelle='curl https://pastebin.com/raw/1qRgMXn5'

# jira
alias jls='jira ls -a robin.yonge'

#
# startup script:
#

# ssh-add keys for git
gAddKey
# load commonly-used secrets as envvars
source /Users/robinyonge/.bash_secrets

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

eval "$(thefuck --alias)"
alias oops='fuck'

# PATH garbage
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=$PATH:/Users/robinyonge/code/git/tractable/cli-tools/bin
export PATH=$PATH:/Users/robinyonge/.kafka/current/bin
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export GOPATH=$HOME/go
export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/terraform@0.12/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"
fpath=($fpath "/Users/robinyonge/.zfunctions")

. /opt/homebrew/opt/asdf/libexec/asdf.sh
export ASDF_HASHICORP_OVERWRITE_ARCH="amd64"

# Spaceship config
# export SPACESHIP_KUBECONTEXT_PREFIX=ctx 
export SPACESHIP_KUBECONTEXT_NAMESPACE_SHOW=false
export SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  # hg            # Mercurial section (hg_branch  + hg_status)
  package       # Package version
  # gradle        # Gradle section
  # maven         # Maven section
  node          # Node.js section
  # ruby          # Ruby section
  # elixir        # Elixir section
  # xcode         # Xcode section
  # swift         # Swift section
  golang        # Go section
  # php           # PHP section
  # rust          # Rust section
  # haskell       # Haskell Stack section
  # julia         # Julia section
  # docker        # Docker section
  aws           # Amazon Web Services section
  # gcloud        # Google Cloud Platform section
  # venv          # virtualenv section
  # conda         # conda virtualenv section
  pyenv         # Pyenv section
  # dotnet        # .NET section
  # ember         # Ember.js section
  kubectl       # Kubectl context section
  terraform     # Terraform workspace section
  exec_time     # Execution time
  line_sep      # Line break
  # battery       # Battery level and status
  # vi_mode       # Vi-mode indicator
  # jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

# substring history
source /opt/homebrew/Cellar/zsh-history-substring-search/1.0.2/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# syntax highlighting
source /Users/robinyonge/code/git/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="/opt/homebrew/opt/terraform@0.12/bin:$PATH"
export PATH="/opt/homebrew/opt/terraform@0.12/bin:$PATH"
