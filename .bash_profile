[ -f ~/.bashrc ] && source ~/.bashrc

WHITE='\[\033[1;37m\]'
LIGHTGRAY='\[\033[0;37m\]'
GRAY='\[\033[1;30m\]'
BLACK='\[\033[0;30m\]'
RED='\[\033[0;31m\]'
LIGHTRED='\[\033[1;31m\]'
GREEN='\[\033[0;32m\]'
LIGHTGREEN='\[\033[1;32m\]'
BROWN='\[\033[0;33m\]' #Orange
YELLOW='\[\033[1;33m\]'
BLUE='\[\033[0;34m\]'
LIGHTBLUE='\[\033[1;34m\]'
PURPLE='\[\033[0;35m\]'
PINK='\[\033[1;35m\]' #Light Purple
CYAN='\[\033[0;36m\]'
LIGHTCYAN='\[\033[1;36m\]'
DEFAULT='\[\033[0m\]'

export PS1="\u@\h:[\w]$ \[$(tput sgr0)\]"

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

pathadd() {
    if [[ ! "$PATH" =~ (^|:)"${1}"(:|$) ]]
    then
        export PATH=${1}:$PATH
    fi
}

if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then
    source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash";
fi

# ================= history ==================
# bind arrows keys to history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# =================== fzf ====================
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git" --glob "!snap/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS=' --height 35% '
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
fi

# ================ git prompt ================
export GIT_PROMPT_ONLY_IN_REPO=1
export GIT_PROMPT_THEME=Evermeet_Ubuntu
if [ -f ~/.bash-git-prompt/gitprompt.sh ]; then
    source ~/.bash-git-prompt/gitprompt.sh
fi

# ================== pyenv ===================
export PYENV_ROOT="$HOME/.pyenv"
pathadd $PYENV_ROOT/bin
if [[ "$PYENV_EVAL" -eq 0 ]]; then
    export PYENV_EVAL=1
    eval "$(pyenv init -)"
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
fi

export BASE_PROMPT=$PS1
function pyenvPrompt {
    if [[ "$(pyenv version-name)" != "system" ]]; then
        PYENV_VER=${YELLOW}$(pyenv version-name)${DEFAULT}
        export PS1="(${PYENV_VER}) "$BASE_PROMPT
    else
        export PS1=$BASE_PROMPT
    fi
}
export PROMPT_COMMAND='pyenvPrompt'


# ============= ssh agent setup ==============
SSH_ENV="$HOME/.ssh/env"
function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
# ============================================
# ============================================
alias vim=nvim

export VISUAL=nvim
export EDITOR=nvim
export SHELL=/bin/bash

pathadd $HOME/.local/bin
pathadd /usr/local/go/bin:~/go/bin

# export MANPAGER="nvim -c 'set ft=man' -"
export MANPAGER='nvim +Man!'
export MANWIDTH=999

eval "$(jump shell)"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# # GIT heart FZF
# # -------------
#
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% --min-height 20 --border --bind ctrl-/:toggle-preview "$@"
}
#
# _gf() {
#   is_in_git_repo || return
#   git -c color.status=always status --short |
#   fzf-down -m --ansi --nth 2..,.. \
#     --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' |
#   cut -c4- | sed 's/.* -> //'
# }
#
#
# _gt() {
#   is_in_git_repo || return
#   git tag --sort -version:refname |
#   fzf-down --multi --preview-window right:70% \
#     --preview 'git show --color=always {}'
# }
#
# _gh() {
#   is_in_git_repo || return
#   git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
#   fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
#     --header 'Press CTRL-S to toggle sort' \
#     --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
#   grep -o "[a-f0-9]\{7,\}"
# }
#
# _gr() {
#   is_in_git_repo || return
#   git remote -v | awk '{print $1 "\t" $2}' | uniq |
#   fzf-down --tac \
#     --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' |
#   cut -d$'\t' -f1
# }
#
_gs() {
  is_in_git_repo || return
  git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' | cut -d: -f1
}
#

_gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s"'
  sed 's/^..//' | cut -d' ' -f1
}

if [[ $- =~ i ]]; then
  bind '"\er": redraw-current-line'
  bind '"\C-g\C-f": "$(_gf)\e\C-e\er"'
  bind '"\C-g\C-g": "$(_gb)"'
  #bind '"\C-g\C-t": "$(_gt)\e\C-e\er"'
  #bind '"\C-g\C-h": "$(_gh)\e\C-e\er"'
  #bind '"\C-g\C-r": "$(_gr)\e\C-e\er"'
  #bind '"\C-g\C-s": "$(_gs)\e\C-e\er"'
fi

