[ -f ~/.bashrc ] && source ~/.bashrc
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then
    source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash";
fi

# ============================================
# ================= history ==================
# ============================================
# bind arrows keys to history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# ============================================
# =================== fzf ====================
# ============================================
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git" --glob "!snap/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS=' --height 35% '
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
fi

# ============================================
# ================ git prompt ================
# ============================================
export GIT_PROMPT_ONLY_IN_REPO=1
export GIT_PROMPT_THEME=Evermeet_Ubuntu
if [ -f ~/.bash-git-prompt/gitprompt.sh ]; then
    source ~/.bash-git-prompt/gitprompt.sh
fi

# ============================================
# ================== pyenv ===================
# ============================================
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
fi

# ============================================
# ============= ssh agent setup ==============
# ============================================
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

export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin:~/go/bin
export PATH=$PATH:/usr/local/libressl/bin
export PATH=$PATH:/usr/local/nvim-linux64/bin

# export MANPAGER="nvim -c 'set ft=man' -"
export MANPAGER='nvim +Man!'
export MANWIDTH=999

eval "$(jump shell)"

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
pyenvPS1() {
    RED='\[\e[0;31m\]'
    BLUE='\[\e[0;34m\]'
    GREEN='\[\e[0;32m\]'
    RESET='\[\e[0m\]'
    [ -z "$PYENV_VIRTUALENV_ORIGINAL_PS1" ] && export PYENV_VIRTUALENV_ORIGINAL_PS1="$PS1"
    [ -z "$PYENV_VIRTUALENV_GLOBAL_NAME" ]  && export PYENV_VIRTUALENV_GLOBAL_NAME="$(pyenv global)"
    VENV_NAME="$(pyenv version-name)"
    VENV_NAME="${VENV_NAME##*/}"
    GLOBAL_NAME="$PYENV_VIRTUALENV_GLOBAL_NAME"

    # non-global versions:
    COLOR="$BLUE"
    # global version:
    [ "$VENV_NAME" == "$GLOBAL_NAME" ] && COLOR="$RED"
    # virtual envs:
    [ "${VIRTUAL_ENV##*/}" == "$VENV_NAME" ] && COLOR="$GREEN"

    if [ -z "$COLOR" ]; then
        PS1="$PYENV_VIRTUALENV_ORIGINAL_PS1"
    else
        PS1="($COLOR${VENV_NAME}$RESET)$PYENV_VIRTUALENV_ORIGINAL_PS1"
    fi
    export PS1
}
export PROMPT_COMMAND="$PROMPT_COMMAND pyenvPS1;"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# VENV_VERSION=3.10.0rc1
# function setup-venv {
#     version="${1:-$VENV_VERSION}"
#     pyenv versions --bare --skip-aliases | grep -q $version
#     if [[ $? -eq 1 ]]
#     then
#         echo "Version $version is not installed."
#         echo "Attempting to install version $version now."
#         pyenv install $version
#     fi
#
#     venv_name=`basename "$PWD"`
#     pyenv virtualenv $version $venv_name
#     echo $venv_name > .python-version
# }
#
#
# # GIT heart FZF
# # -------------
#
# is_in_git_repo() {
#   git rev-parse HEAD > /dev/null 2>&1
# }
#
# fzf-down() {
#   fzf --height 50% --min-height 20 --border --bind ctrl-/:toggle-preview "$@"
# }
#
# _gf() {
#   is_in_git_repo || return
#   git -c color.status=always status --short |
#   fzf-down -m --ansi --nth 2..,.. \
#     --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' |
#   cut -c4- | sed 's/.* -> //'
# }
#
# _gb() {
#   is_in_git_repo || return
#   git branch -a --color=always | grep -v '/HEAD\s' | sort |
#   fzf-down --ansi --multi --tac --preview-window right:70% \
#     --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
#   sed 's/^..//' | cut -d' ' -f1 |
#   sed 's#^remotes/##'
# }
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
# _gs() {
#   is_in_git_repo || return
#   git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' | cut -d: -f1
# }
#
# if [[ $- =~ i ]]; then
#   bind '"\er": redraw-current-line'
#   bind '"\C-g\C-f": "$(_gf)\e\C-e\er"'
#   bind '"\C-g\C-g": "$(_gb)\e\C-e\er"'
#   #bind '"\C-g\C-t": "$(_gt)\e\C-e\er"'
#   #bind '"\C-g\C-h": "$(_gh)\e\C-e\er"'
#   #bind '"\C-g\C-r": "$(_gr)\e\C-e\er"'
#   #bind '"\C-g\C-s": "$(_gs)\e\C-e\er"'
# fi
#
#
#
#
