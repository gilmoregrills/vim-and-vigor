# Path to the bash it configuration
export BASH_IT="/Users/rfarrow-yonge/.bash_it"

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

# Aliases:
# General:
alias reload="bash-it reload"
alias rr="reload"
alias shebang='echo "#!/usr/bin/env bash"'
alias typora="open -a typora"
alias watch="watch "

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

# Kubernetes
alias k="kubectl"
alias kuebctl="kubectl" # most common typo lmao
alias kontext="kubectl config use-context" # switch context and print namespaces to test
alias kns="kubectl get ns"

# Docker
alias d="docker"

# thefuck
eval $(thefuck --alias)

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"                  # Go to previous dir with -
alias cd.='cd $(readlink -f .)'    # Go to real dir (i.e. if current dir is linked)

# Network
alias ipl="echo \"private ip:\"; ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1';echo \"public ip:\"; curl whatismyip.akamai.com; echo"
alias pcurl='curl --silent -o /dev/null -v -H "Pragma: akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no"'

alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

alias idGroups="id -a | sed 's|,|\n|g'"

# Load Bash It
source "$BASH_IT"/bash_it.sh
