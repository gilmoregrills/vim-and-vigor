# source /Users/robinyonge/code/git/marlonrichert/zsh-autocomplete/zsh-autocomplete.plugin.zsh

eval "$(mise activate zsh)"
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

function getPublicKey() {
  ssh-keygen -y -f ${1}
}

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
      echo "Select aws profile to use: "
      vars=(`aws configure list-profiles`)
      choice=$(gum choose "${vars[@]}")
      export AWS_PROFILE="${choice}"
      echo "Current profile is:";
      aws configure list;
    else
      export AWS_PROFILE=$1;
      echo "Current profile is:";
      aws configure list;
  fi
};

# usage:
# jbranch <ISSUE_ID>
# to checkout a new branch with the issue ID in question
# and set the ticket to in progress
function jbranch() {
  echo "Select Jira ticket:"
  SAVEIFS=${IFS}
  IFS=$'\n'
  VARS=($(jira mine))
  IFS=${SAVEIFS}
  CHOICE=$(gum choose "${VARS[@]}")
  PREFIX=$(gum choose --header="Select prefix:" "feature" "fix" "chore" "docs" "test" "refactor" "style")
  TICKETID=$(echo ${CHOICE} | awk -F ':' '{print $1}')
  git checkout -b "${PREFIX}/${TICKETID}"
  git push --set-upstream origin ${TICKETID}
  return ${TICKETID}
}

function jch() {
  echo "Select Jira ticket:"
  SAVEIFS=${IFS}
  IFS=$'\n'
  VARS=(`jira mine`)
  IFS=${SAVEIFS}
  CHOICE=$(gum choose "${VARS[@]}")
  echo ${CHOICE}
  TICKETID=$(echo ${CHOICE} | awk -F ':' '{print $1}')
  git checkout ${TICKETID}
}

# usage:
# from a pushed branch where branch name == jira ticket run
# jpr
function jpr() {
  ID=$(git rev-parse --abbrev-ref HEAD)
  jira pr ${ID}
  # remove --web and you'll get prompted to fill in title and description in-line
  gh pr create
}

function gchb() {
  SAVEIFS=${IFS}
  IFS=$'\n'
  VARS=($(git branch --format='%(refname:short)'))
  IFS=${SAVEIFS}
  BRANCH=$(gum choose --header="Select a branch:" "${VARS[@]}")
  if [ -z "${BRANCH}" ]; then
    echo "No branch selected"
    return 1
  fi
  echo "Checking out branch: ${BRANCH}"
  git checkout "${BRANCH}"
}

function kubectx() {
  SAVEIFS=${IFS}
  IFS=$'\n'
  VARS=($(kubectl config get-contexts --output=name | awk '{print $1}' | grep -v '*'))
  IFS=${SAVEIFS}
  CHOICE=$(gum choose --header="Select context:" "${VARS[@]}")
  kubectl config use-context ${CHOICE}
  export KUBE_CONTEXT=${CHOICE}
  export KUBE_NAMESPACE=$(kubectl config view --minify --output 'jsonpath={..namespace}')
}

function kubens() {
  echo "Select namespace:"
  SAVEIFS=${IFS}
  IFS=$'\n'
  VARS=($(kubectl get namespaces --no-headers -o custom-columns=:metadata.name))
  IFS=${SAVEIFS}
  CHOICE=$(gum choose "${VARS[@]}")
  kubectl config set-context --current --namespace=${CHOICE}
  export KUBE_CONTEXT=$(kubectl config current-context)
  export KUBE_NAMESPACE=${CHOICE}
}

function kube_set() {
  export KUBE_CONTEXT=$(kubectl config current-context)
  export KUBE_NAMESPACE=$(kubectl config view --minify --output 'jsonpath={..namespace}')
}

function kube_unset() {
  unset KUBE_CONTEXT
  unset KUBE_NAMESPACE
  kubectl config unset current-context
}

#
# Aliases:
#

# General:
alias watch="watch "
alias vim="nvim"
alias sed="gsed"
alias cssh="csshx"
alias find="gfind"
alias pico8="pico8 -home ~/pico8/"
alias vimrc="nvim ~/.config/nvim"
alias zshrc="nvim ~/.zshrc"
alias reload='source ~/.zshrc;echo "sourced ~/.zshrc"'
alias :q='exit'
alias hfcli='huggingface-cli'

# Git:
alias g="git"
alias gs="git status"
alias ga="git add"
alias gb="git branch"
alias gch="git checkout"
alias gcm="git commit -m"

function gchm() {
  ORIGIN=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  PRIMARY_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  git checkout ${PRIMARY_BRANCH}
  git fetch
}

function gpm() {
  PRIMARY_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  git pull origin ${PRIMARY_BRANCH}
}
function gresetm() {
  PRIMARY_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  git fetch origin
  git reset --hard origin/${PRIMARY_BRANCH}
}

function bclone() {
  git clone git@github.com:BeameryHQ/${1}.git
};

# Terraform
alias tf="terraform"
alias terraform-test="terraform"
alias tf-fmt="terraform fmt -recursive ."

# Kubernetes
alias kuebctl="kubectl"
export MINIKUBE_IN_STYLE=1
export KUBE_EDITOR=nvim

# Docker
alias d="docker"

# Easier navigation: .., ..., ...., ....., ~ and -
alias ls="eza --across"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"                  # Go to previous dir with -
alias ll="eza -la --git"

# OSX
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# misc
alias 1pass='eval $(op signin tractable)'
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
alias myip='curl http://whatismyip.akamai.com/'

# PATH garbage
export GOPATH=$HOME/go
export GOBIN="/Users/robinyonge/go/bin"
export PATH="$PATH:$HOME/.poetry/bin:/usr/local/sbin:$HOME/.cargo/bin:/Users/robinyonge/code/git/tractable/cli-tools/bin:/Users/robinyonge/.kafka/current/bin:${KREW_ROOT:-$HOME/.krew}/bin:$GOBIN:/usr/local/opt/findutils/libexec/gnubin:/Users/robinyonge/.local/bin:${KREW_ROOT:-$HOME/.krew}/bin:/Users/robin.lightfoot/.local/bin"

eval "$(/opt/homebrew/bin/brew shellenv)"

# custom prompt stuff
autoload -Uz vcs_info
autoload -U colors && colors
SUCCESS_EMOJIS=("💞" "💖" "✨")
FAILURE_EMOJIS=("☠️" "👹" "💔" "💥")

setopt prompt_subst
setopt PROMPT_SUBST
zstyle ':vcs_info:git:*' check_for_changes true
zstyle ':vcs_info:git:*' check_for_staged_changes true
zstyle ':vcs_info:git:*' formats ":%s(%b)"

precmd() {
  myprompt
}

function myprompt() {
  RETVAL=$?
  vcs_info

  local 'STATUS_COLOR' 'PROMPTMOJI'
  if [[ $RETVAL -eq 0 ]]; then
    STATUS_COLOR=green
    SIZE=${#SUCCESS_EMOJIS[@]}
    INDEX=$(($RANDOM % $SIZE))
    PROMPTMOJI="${SUCCESS_EMOJIS[$INDEX + 1]}"
  else
    STATUS_COLOR=red
    SIZE=${#FAILURE_EMOJIS[@]}
    INDEX=$(($RANDOM % $SIZE))
    PROMPTMOJI="${FAILURE_EMOJIS[$INDEX + 1]}"
  fi

  if [ $FASTPROMPT ]; then
    PS1=%F{blue}%~' '"🏃‍♀️"$'\n'%F{$STATUS_COLOR}'↳ '%f
    return
  fi

  local 'USING_PROMPT'

  PWD=$(pwd)

  # local 'TF_VERSION_PROMPT'
  if [[ $(mise tool terraform --config-source --json | jq -r .path | xargs dirname) == ${PWD} ]]; then
    if [[ -z $USING_PROMPT ]]; then
      USING_PROMPT="%F{magenta}tf$(mise tool terraform --active)%f "
    else
      USING_PROMPT="${USING_PROMPT} and %F{magenta}tf$(mise tool terraform --active)%f "
    fi
  fi

  # local NODE_VERSION=$(mise tool node --json)
  if [[ $(mise tool node --config-source --json | jq -r .path | xargs dirname) == ${PWD} ]]; then
    if [[ -z $USING_PROMPT ]]; then
      USING_PROMPT="%F{magenta}node$(mise tool node --active)%f "
    else
      USING_PROMPT="${USING_PROMPT}and %F{magenta}node$(mise tool node --active)%f "
    fi
  fi

  if [[ -z $USING_PROMPT ]]; then
    USING_PROMPT=""
  else
    USING_PROMPT="using ${USING_PROMPT}"
  fi

  local 'AWS_PROMPT'
  if [ -z $AWS_PROFILE ]; then
    AWS_PROMPT=""
  else
    AWS_PROMPT="on %F{yellow}$AWS_PROFILE%f "
  fi

  if [[ -z "$KUBE_CONTEXT" ]] ; then
    KUBE_CONTEXT_PROMPT=""
  else
    KUBE_CONTEXT_PROMPT="on %F{white}${KUBE_CONTEXT}(${KUBE_NAMESPACE})%f "
  fi

  PS1=%F{blue}%~%f%F{green}${vcs_info_msg_0_}%f' '"$AWS_PROMPT""$KUBE_CONTEXT_PROMPT""$USING_PROMPT""$TF_VERSION_PROMPT""$NODE_VERSION_PROMPT""$PROMPTMOJI"$'\n'%F{$STATUS_COLOR}'↳ '%f
  # PS0=$'\nps0'
  # PS2="ps2 > "
  return
}

alias fastprompt="export FASTPROMPT=true"
alias slowprompt="unset FASTPROMPT"

export K9S_CONFIG_DIR="/Users/robin.lightfoot/.config/k9s"

# syntax highlighting
# source /Users/robinyonge/code/git/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# https://vitormv.github.io/fzf-themes#eyJib3JkZXJTdHlsZSI6InJvdW5kZWQiLCJib3JkZXJMYWJlbCI6IiIsImJvcmRlckxhYmVsUG9zaXRpb24iOjAsInByZXZpZXdCb3JkZXJTdHlsZSI6InJvdW5kZWQiLCJwYWRkaW5nIjoiMCIsIm1hcmdpbiI6IjAiLCJwcm9tcHQiOiI+ICIsIm1hcmtlciI6Ij4iLCJwb2ludGVyIjoi4peGIiwic2VwYXJhdG9yIjoiIiwic2Nyb2xsYmFyIjoiIiwibGF5b3V0IjoiZGVmYXVsdCIsImluZm8iOiJyaWdodCIsImNvbG9ycyI6ImZnOiNjOGIzYjMsZmcrOiM0MTQxNDEsYmc6I2ZiZjhmOCxiZys6I2ZiZjhmOCxobDojYzhiM2IzLGhsKzojNDE0MTQxLGluZm86I2FmYWY4NyxtYXJrZXI6I2Y2ZTNlNyxwcm9tcHQ6I2Y2ZTNlNyxzcGlubmVyOiNlZWFhYmUscG9pbnRlcjojZWVhYWJlLGhlYWRlcjojODJiNGUzLGJvcmRlcjojY2ZjOWY0LGxhYmVsOiNhZWFlYWUscXVlcnk6Izk0ODQ4NCJ9
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#c8b3b3,fg+:#414141,bg:#fbf8f8,bg+:#fbf8f8
  --color=hl:#c8b3b3,hl+:#414141,info:#afaf87,marker:#f6e3e7
  --color=prompt:#f6e3e7,spinner:#eeaabe,pointer:#eeaabe,header:#82b4e3
  --color=border:#cfc9f4,label:#aeaeae,query:#948484
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="◆" --separator="" --scrollbar=""
  --info="right"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

eval "$(atuin init zsh)"

source ~/.zsh_secrets

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/robin.lightfoot/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/robin.lightfoot/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/robin.lightfoot/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/robin.lightfoot/bin/google-cloud-sdk/completion.zsh.inc'; fi
# Beamery Platform Tooling setup
[ -s ~/.beamery-tooling/bin/tooling-setup.sh ] && source ~/.beamery-tooling/bin/tooling-setup.sh
# hook direnv in zshrc
eval "$(direnv hook zsh)"
