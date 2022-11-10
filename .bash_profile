if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# set colored-stats on
bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias rg='rg --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vim=nvim
alias tree='tree -I node_modules'

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
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"
alias pip="$PYENV_ROOT/shims/pip"
pathadd $PYENV_ROOT/bin
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


# nvm
export NVM_DIR="$HOME/.nvm"
if [[ "$NVM_EVAL" -eq 0 ]]; then
    NVM_EVAL=1
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"
    [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

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

if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    # Set config variables first
    GIT_PROMPT_ONLY_IN_REPO=1
    # GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status
    # GIT_PROMPT_IGNORE_SUBMODULES=1 # uncomment to avoid searching for changed files in submodules
    # GIT_PROMPT_WITH_VIRTUAL_ENV=0 # uncomment to avoid setting virtual environment infos for node/python/conda environments
    # GIT_PROMPT_VIRTUAL_ENV_AFTER_PROMPT=1 # uncomment to place virtual environment infos between prompt and git status (instead of left to the prompt)

    # GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch
    # GIT_PROMPT_SHOW_UNTRACKED_FILES=normal # can be no, normal or all; determines counting of untracked files

    # GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0 # uncomment to avoid printing the number of changed files

    # GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh # uncomment to support Git older than 1.7.10

    # GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
    # GIT_PROMPT_END=...      # uncomment for custom prompt end sequence

    # as last entry source the gitprompt script
    GIT_PROMPT_THEME=Solarized # use custom theme specified in file GIT_PROMPT_THEME_FILE (default ~/.git-prompt-colors.sh)
    #  GIT_PROMPT_THEME_FILE=~/.git-prompt-colors.sh
    # # GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme
    source ~/.bash-git-prompt/gitprompt.sh
fi

if [ -f ~/.git-completion.bash ]; then
    # curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
  . ~/.git-completion.bash
fi

fd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}
export PATH="/usr/local/opt/binutils/bin:$PATH"

