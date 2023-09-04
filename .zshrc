source /Users/robinyonge/code/git/marlonrichert/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Functions:

function v2g() {
    src="" # required
    target="" # optional (defaults to source file name)
    resolution="" # optional (defaults to source video resolution)
    fps=10 # optional (defaults to 10 fps -- helps drop frames)

    while [ $# -gt 0 ]; do
        if [[ $1 == *"--"* ]]; then
                param="${1/--/}"
                declare $param="$2"
        fi
        shift
    done

    if [[ -z $src ]]; then
        echo -e "\nPlease call 'v2g --src <source video file>' to run this command\n"
        return 1
    fi

    if [[ -z $target ]]; then
        target=$src
    fi

    basename=${target%.*}
    [[ ${#basename} = 0 ]] && basename=$target
    target="$basename.gif"

    if [[ -n $fps ]]; then
        fps="-r $fps"
    fi

    if [[ -n $resolution ]]; then
        resolution="-s $resolution"
    fi

    runcommand="ffmpeg -i "$src" -pix_fmt rgb8 $fps $resolution "$target" && gifsicle -O3 "$target" -o "$target""

    echo ""
    echo ".------------------------."
    echo "|\\\\////////       90 min |"
    echo "| \\/  __  ______  __     |"
    echo "|    /  \|\.....|/  \    |"
    echo "|    \__/|/_____|\__/    |"
    echo "| A                      |"
    echo "|    ________________    |"
    echo "|___/_._o________o_._\___|"
    echo ""
    echo "ツ running >> $runcommand"
    echo "ツ ..."
    echo ""

    eval " $runcommand"
    osascript -e "display notification \"$target successfully converted and saved\" with title \"v2g complete\""
}

function getPublicKey() {
  ssh-keygen -y -f ${1}
}

function pglogin(){
  case $1 in
    dev)
      export PGUSER=$(op item get --vault INFRA "Databases: readonly - postgres (all environments)" --fields username)
      export PGPASSWORD=$(op item get --vault INFRA "Databases: readonly - postgres (all environments)" --fields password)
      ;;
    integ)
      export PGUSER=$(op item get --vault INFRA "Databases: readonly - postgres (all environments)" --fields username)
      export PGPASSWORD=$(op item get --vault INFRA "Databases: readonly - postgres (all environments)" --fields password)
      ;;
    eu)
      export PGUSER=$(op item get --vault INFRA "Databases: readonly - postgres (all environments)" --fields username)
      export PGPASSWORD=$(op item get --vault INFRA "Databases: readonly - postgres (all environments)" --fields password)
      ;;
    us)
      export PGUSER=$(op item get --vault INFRA "Databases: readonly - postgres (all environments)" --fields username)
      export PGPASSWORD=$(op item get --vault INFRA "Databases: readonly - postgres (all environments)" --fields password)
      ;;
    jp)
      export PGUSER=$(op item get --vault INFRA "Databases: readonly - postgres (all environments)" --fields username)
      export PGPASSWORD=$(op item get --vault INFRA "Databases: readonly - postgres (all environments)" --fields password)
      ;;
  esac

  export PGDATABASE="${2}"
  export PGHOST="postgres.${1}.tractable.io"
  pgcli
}

function gAddKey() {
  eval "$(ssh-agent)"
  ssh-add ~/.ssh/id_rsa_github ~/.ssh/id_rsa_tractable
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
  VARS=(`jira mine`)
  IFS=${SAVEIFS}
  CHOICE=$(gum choose "${VARS[@]}")
  echo ${CHOICE}
  TICKETID=$(echo ${CHOICE} | awk -F ':' '{print $1}')
  jira progress ${TICKETID}
  git checkout -b ${TICKETID}
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

function gSuiteSA() {
  export GOOGLE_CLOUD_KEYFILE_JSON=$(aws --profile=tractableai-shared --region=eu-west-2 ssm get-parameter --name /prod/infrastructure/tf-env-gsuite/gsuite/service-account --with-decryption | jq -jr '.Parameter.Value')
}

#
# Aliases:
#

# General:
alias shebang='echo "#!/usr/bin/env bash"'
alias watch="watch "
alias vim="nvim"
alias sed="gsed"
alias cssh="csshx"
alias idGroups="id -a | sed 's|,|\n|g'"
alias find="gfind"
alias pico8="pico8 -home ~/pico8/"
alias python="python3"
alias vimrc="nvim ~/.config/nvim"
alias zshrc="nvim ~/.zshrc"
alias reload='source ~/.zshrc;echo "sourced ~/.zshrc"'
alias :q='exit'

# kitty
alias kdiff="kitty +kitten diff"
alias hg="kitty +kitten hyperlinked_grep"
alias kssh="kitty +kitten ssh"
alias edit="edit-in-kitty --cwd --type=window"


# Git:
alias g="git"
alias gs="git status"
alias ga="git add"
alias gb="git branch"
alias gch="git checkout"

function gc() {
  TYPE=$(gum choose "fix" "feat" "chore" "docs" "style" "refactor" "test" "revert")
  # test -n "$SCOPE" && SCOPE="($SCOPE)"
  while True ; do
    SUMMARY=$(gum input --value "$TYPE: " --placeholder "Summary of this change")
    [[ ${#SUMMARY} -le 50 ]] && break
    echo "Sorry that commit summary was ${#SUMMARY} characters, please try to keep it below 50."
  done
  DESCRIPTION=$(gum write --placeholder "Details of this change (CTRL+D to finish)")
  gum confirm "Commit changes?" && git commit -m "$SUMMARY" -m "$DESCRIPTION"
}

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
function tclone() {
  git clone git@github.com:tractableai/${1}.git
};

# Terraform
alias tf="terraform"
alias tf-fmt="terraform fmt -recursive ."
alias tfplan="terraform plan -no-color"
alias tfapply="terraform apply -no-color -auto-approve"

# Kubernetes
alias kuebctl="kubectl" # most common typo lmao
alias unset_kubecontext="kubectl config unset current-context"
export MINIKUBE_IN_STYLE=1
export KUBE_EDITOR=nvim

# Docker
alias d="docker"
alias dockerKillZombies="docker ps | grep hours | awk '{print $1}' | xargs docker kill"
alias dockerHardReset="docker ps -q | xargs -L1 docker stop && test -z \"$(docker ps -q 2>/dev/null)\" && osascript -e 'quit app \"Docker\"' && open --background -a Docker"

# Easier navigation: .., ..., ...., ....., ~ and -
alias ls="exa --across"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"                  # Go to previous dir with -
alias ll="exa -la --git"

# OSX
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

# misc
alias 1pass='eval $(op signin tractable)'
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
alias myip='curl http://whatismyip.akamai.com/'

# load commonly-used secrets as envvars
source /Users/robinyonge/.bash_secrets

eval "$(thefuck --alias)"
alias oops='fuck'

# PATH garbage
export GOPATH=$HOME/go
export GOBIN="/Users/robinyonge/go/bin"
export PATH="$PATH:$HOME/.poetry/bin:/usr/local/sbin:$HOME/.cargo/bin:/Users/robinyonge/code/git/tractable/cli-tools/bin:/Users/robinyonge/.kafka/current/bin:${KREW_ROOT:-$HOME/.krew}/bin:$GOBIN:/usr/local/opt/findutils/libexec/gnubin:/Users/robinyonge/.local/bin"
fpath=($fpath "/Users/robinyonge/.zfunctions")

eval "$(/opt/homebrew/bin/brew shellenv)"

# custom prompt stuff
autoload -Uz vcs_info
autoload -U colors && colors
SUCCESS_EMOJIS=("🙆‍♀️" "💁‍♀️" "🙋‍♀️")
FAILURE_EMOJIS=("🙅‍♀️" "🤦‍♀️" "🤷‍♀️")

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

  local 'TF_VERSION_PROMPT'
  if [ -e .terraform-version ]; then
    TF_VERSION_PROMPT="using %F{magenta}tf$(tfenv version-name)%f "
  else
    TF_VERSION_PROMPT=""
  fi

  local 'AWS_PROMPT'
  if [ -z $AWS_PROFILE ]; then
    AWS_PROMPT=""
  else
    AWS_PROMPT="on %F{yellow}$AWS_PROFILE%f "
  fi

  if kubectl config current-context &> /dev/null ; then
    KUBE_CONTEXT_PROMPT="on %F{cyan}$(kubectl config current-context)($(kubens -c))%f "
  else
    KUBE_CONTEXT_PROMPT=""
  fi

  PS1=%F{blue}%~%f%F{green}${vcs_info_msg_0_}%f' '"$AWS_PROMPT""$TF_VERSION_PROMPT""$KUBE_CONTEXT_PROMPT""$PROMPTMOJI"$'\n'%F{$STATUS_COLOR}'↳ '%f
  # PS0=$'\nps0'
  # PS2="ps2 > "
  return
}

alias fastprompt="export FASTPROMPT=true"
alias slowprompt="unset FASTPROMPT"

# syntax highlighting
source /Users/robinyonge/code/git/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# substring history
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/robinyonge/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/robinyonge/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/robinyonge/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/robinyonge/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
