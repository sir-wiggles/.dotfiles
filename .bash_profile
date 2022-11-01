if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias rg='rg --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vim=nvim

cG='\[\033[1;32m\]'
cO='\[\033[0;33m\]'
cD='\[\033[0m\]'

export PS1="${cG}\u${cD}@${cG}\h${cD}:${cO}\w${cD}\$ "
export BASH_SILENCE_DEPRECATION_WARNING=1
export EDITOR=nvim
export MANPAGER='nvim +Man!'
export MANWIDTH=120
export SHELL=/bin/bash
export VISUAL=nvim
export PYTHONDONTWRITEBYTECODE=1

pathadd() {
    if [[ ! "$PATH" =~ (^|:)"${1}"(:|$) ]]; then
        export PATH=${1}:$PATH
    fi
}

# kitty
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then
    source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash";
fi

# history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git" --glob "!snap/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS=' --height 35% '
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
pathadd $PYENV_ROOT/bin
if [[ "$PYENV_EVAL" -eq 0 ]]; then
    export PYENV_EVAL=1
    eval "$(pyenv init --path --no-rehash)"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
if [[ "$NVM_EVAL" -eq 0 ]]; then
    NVM_EVAL=1
    source "$NVM_DIR/nvm.sh"  # This loads nvm
    source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# ssh agent setup
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

# golang
pathadd $HOME/.local/bin
pathadd /usr/local/go/bin:~/go/bin

# jump
eval "$(jump shell)"

 [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

fd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}
