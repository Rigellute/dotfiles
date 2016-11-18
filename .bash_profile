# Postgres
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

# Go
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Aliases
alias hrun-notifs="heroku run babel-node run-all-workers.js --app rota-notifications-staging"
alias hrun-logic="heroku run babel-node server/scripts/run.js --app rota-logic-staging"
alias cdr="cd /Users/alexanderkeliris/Documents/React/rota"
alias refb=". ~/.bash_profile"
alias atombash="atom ~/.bash_profile"
alias rota-all="(export MS_RUNNING=true && export DEV_USER='alexanderkeliris' && rota run --all)"
alias run-logic="node server/scripts/index.js"
alias run-logic-t="(export MS_RUNNING=true && node server/scripts/index.js)"
alias run-matcher="node RotaServices/Matcher/server/worker/run.js"
alias start-n="(export MS_RUNNING=true && node RotaServices/Notifications/index.js)"
alias start-l="(export MS_RUNNING=true && node RotaServices/Logic/index.js)"
alias run-ak="babel-node RotaApi/ak-test.js"
alias hrun-matcher="heroku run node server/worker/run.js --app rota-matcher-staging"

export NPM_TOKEN=24f00170-c29d-4064-8ec8-e18084b64294

# Quick git deploy cmd
up(){
    git add -A
    git commit -m "$@"
    git push
    say woooosh
}
# Quick git deploy cmd
com(){
    git add -A
    git commit -m "$@"
}

# Create boilerplate files (package.json, .scss, filename.js etc.)
# Usage: cd your_dir && boiler
boiler(){

  DIR_NAME=${PWD##*/}

  if [ "$#" -ne 0 ];
    then local DIR_NAME="$@"
  fi
  touch $DIR_NAME.scss
  touch $DIR_NAME.js
  # touch $DIR_NAME.reducer.js
  # touch $DIR_NAME.actions.js
  touch package.json
  echo "@import \"global.scss\";" >> $DIR_NAME.scss
  echo "import React, { Component } from 'react';
import { connect } from 'react-redux';
import './$DIR_NAME.scss';" >> $DIR_NAME.js
  echo "{
  \"name\": \"$DIR_NAME\",
  \"version\": \"0.0.1\",
  \"main\": \"./$DIR_NAME.js\",
  \"private\": true
}" >> package.json
  echo "Boiler Success!"
}

# Load our dotfiles like ~/.bash_prompt, etc…
#   ~/.extra can be used for settings you don’t want to commit,
#   Use it to configure your PATH, thus it being first in line.
# for file in ~/.{extra,bash_prompt,exports,aliases,functions}; do
#     [ -r "$file" ] && source "$file"
# done
# unset file
for file in ~/.{extra,bash_prompt,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done
unset file

# to help sublimelinter etc with finding my PATHS
# case $- in
#    *i*) source ~/.extra
# esac


# generic colouriser
GRC=`which grc`
if [ "$TERM" != dumb ] && [ -n "$GRC" ]
    then
        alias colourify="$GRC -es --colour=auto"
        alias configure='colourify ./configure'
        for app in {diff,make,gcc,g++,ping,traceroute}; do
            alias "$app"='colourify '$app
    done
fi

# highlighting inside manpages and elsewhere
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

##
## gotta tune that bash_history…
##

# timestamps for later analysis. www.debian-administration.org/users/rossen/weblog/1
export HISTTIMEFORMAT='%F %T '

# keep history up to date, across sessions, in realtime
#  http://unix.stackexchange.com/a/48113
export HISTCONTROL=ignoredups:erasedups         # no duplicate entries
export HISTSIZE=100000                          # big big history (default is 500)
export HISTFILESIZE=$HISTSIZE                   # big big history
which shopt > /dev/null && shopt -s histappend  # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# ^ the only downside with this is [up] on the readline will go over all history not just this bash session.



##
## hooking in other apps…
##
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"


# z beats cd most of the time.
#   github.com/rupa/z
source ~/code/z/z.sh



##
## Completion…
##

if [[ -n "$ZSH_VERSION" ]]; then  # quit now if in zsh
    return 1 2> /dev/null || exit 1;
fi;

# bash completion.
if  which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
    source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# homebrew completion
# if  which brew > /dev/null; then
#     source `brew --repository`/Library/Contributions/brew_bash_completion.sh
# fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type __git_complete &> /dev/null; then
    __git_complete g __git_main
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults


##
## better `cd`'ing
##

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;
