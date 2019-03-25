#!/usr/bin/env bash
SCM_GIT_CHAR="${blue}± "
SCM_HG_CHAR="☿ "
SCM_SVN_CHAR="⑆ "
SCM_NONE_CHAR="${purple}"
SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓"
SCM_THEME_PROMPT_PREFIX="${cyan}|"
SCM_THEME_PROMPT_SUFFIX="${cyan}| "
SCM_GIT_AHEAD_CHAR="${red}+"
SCM_GIT_BEHIND_CHAR="${green}-"
SCM_GIT_DETACHED_CHAR='⌿'
SCM_GIT_AHEAD_CHAR="${red}↑"
SCM_GIT_BEHIND_CHAR="${green}↓"

GIT_THEME_PROMPT_DIRTY=" ${bold_red}✗"
GIT_THEME_PROMPT_CLEAN=" ${bold_green}✓"
GIT_THEME_PROMPT_PREFIX="${white}| "
GIT_THEME_PROMPT_SUFFIX="${purple} "

VIRTUALENV_THEME_PROMPT_PREFIX="${cyan}|"
VIRTUALENV_THEME_PROMPT_SUFFIX="${cyan}|"

function git_prompt_info {
  git_prompt_vars
  echo -e "$SCM_PREFIX$SCM_BRANCH$SCM_STATE$SCM_GIT_AHEAD$SCM_GIT_BEHIND$SCM_GIT_STASH$SCM_SUFFIX"
}

LAST_PROMPT=""
function prompt_command() {
    local new_PS1="${bold_cyan}$(scm_char)${yellow}$(ruby_version_prompt)${white}\w $(scm_prompt_info)"
    local new_prompt=$(PS1="$new_PS1" "$BASH" --norc -i </dev/null 2>&1 | sed -n '${s/^\(.*\)exit$/\1/p;}')

    if [ "$LAST_PROMPT" = "$new_prompt" ]; then
        new_PS1="${purple}"
    else
        LAST_PROMPT="$new_prompt"
    fi

    local wrap_char=""
    [[ $COLUMNS && ${#new_PS1} > $(($COLUMNS/1)) ]] && wrap_char="\n"
    PS1="${new_PS1}${magenta}${wrap_char}→${reset_color} "
}

safe_append_prompt_command prompt_command
