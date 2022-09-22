#
# Prompt character
#

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_CHAR_PREFIX="${SPACESHIP_CHAR_PREFIX=""}"
SPACESHIP_CHAR_PREFIX_ROOT="${SPACESHIP_CHAR_PREFIX=""}"
#SPACESHIP_CHAR_PREFIXES_FAILURE="${SPACESHIP_CHAR_PREFIXES_FAILURE=$SPACESHIP_CHAR_PREFIX}"
#SPACESHIP_CHAR_PREFIXES_SUCCESS="${SPACESHIP_CHAR_PREFIXES_SUCCESS=$SPACESHIP_CHAR_PREFIX}"
SPACESHIP_CHAR_SUFFIX="${SPACESHIP_CHAR_SUFFIX=""}"
SPACESHIP_CHAR_SYMBOL="${SPACESHIP_CHAR_SYMBOL="➜ "}"
SPACESHIP_CHAR_SYMBOL_ROOT="${SPACESHIP_CHAR_SYMBOL_ROOT="$SPACESHIP_CHAR_SYMBOL"}"
SPACESHIP_CHAR_SYMBOL_SECONDARY="${SPACESHIP_CHAR_SYMBOL_SECONDARY="$SPACESHIP_CHAR_SYMBOL"}"
SPACESHIP_CHAR_COLOR_SUCCESS="${SPACESHIP_CHAR_COLOR_SUCCESS="green"}"
SPACESHIP_CHAR_COLOR_FAILURE="${SPACESHIP_CHAR_COLOR_FAILURE="red"}"
SPACESHIP_CHAR_COLOR_SECONDARY="${SPACESHIP_CHAR_COLOR_SECONDARY="yellow"}"

# obvious success emojis
SPACESHIP_CHAR_PREFIXES_SUCCESS=("🙆‍♀️" "💁‍♀️" "🙋‍♀️" "✨")
# mostly obvious icons for failure
SPACESHIP_CHAR_PREFIXES_FAILURE=("🙅‍♀️" "🤦‍♀️" "🤷‍♀️")
# longer list, includes frowny faces
#SPACESHIP_CHAR_PREFIXES_FAILURE=("🙅‍♀️" "🙎‍♀️" "🤦‍♀️" "🤷‍♀️" "🙎‍♀️")


# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Paint $PROMPT_SYMBOL in red if previous command was fail and
# paint in green if everything was OK.
spaceship_char() {
  local 'color' 'char' 

  if [[ $RETVAL -eq 0 ]]; then
    color="$SPACESHIP_CHAR_COLOR_SUCCESS"
    size=${#SPACESHIP_CHAR_PREFIXES_SUCCESS[@]}
    index=$(($RANDOM % $size))
    SPACESHIP_CHAR_PREFIX="${SPACESHIP_CHAR_PREFIXES_SUCCESS[$index + 1]}"
  else
    color="$SPACESHIP_CHAR_COLOR_FAILURE"
    size=${#SPACESHIP_CHAR_PREFIXES_FAILURE[@]}
    index=$(($RANDOM % $size))
    SPACESHIP_CHAR_PREFIX="${SPACESHIP_CHAR_PREFIXES_FAILURE[$index + 1]}"
  fi

  if [[ $UID -eq 0 ]]; then
    char="$SPACESHIP_CHAR_SYMBOL_ROOT"
  else
    char="$SPACESHIP_CHAR_SYMBOL"
  fi

  spaceship::section \
    "$color" \
    "$SPACESHIP_CHAR_PREFIX" \
    "$char" \
    "$SPACESHIP_CHAR_SUFFIX"
}
