
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

export BASH_SILENCE_DEPRECATION_WARNING=1
export EDITOR=nvim
export MANPAGER='nvim +Man!'
export MANWIDTH=120
export SHELL=/bin/bash
export VISUAL=nvim
export PYTHONDONTWRITEBYTECODE=1
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git" --glob "!snap/*"'
export RIPGREP_CONFIG_PATH='~/.ripgreprc'
export PATH=$HOME/go/bin:$PATH


bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'


# =====================================================================================


# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Path to the bash it configuration
export BASH_IT="/Users/jeffor/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='standard'

# Some themes can show whether `sudo` has a current token or not.
# Set `$THEME_CHECK_SUDO` to `true` to check every prompt:
#THEME_CHECK_SUDO='true'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# (Advanced): Change this to the name of the main development branch if
# you renamed it or if it was changed for some reason
# export BASH_IT_DEVELOPMENT_BRANCH='master'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to the location of your work or project folders
#BASH_IT_PROJECT_PATHS="${HOME}/Projects:/Volumes/work/src"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true
# Set to actual location of gitstatus directory if installed
#export SCM_GIT_GITSTATUS_DIR="$HOME/gitstatus"
# per default gitstatus uses 2 times as many threads as CPU cores, you can change this here if you must
#export GITSTATUS_NUM_THREADS=8

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# If your theme use command duration, uncomment this to
# enable display of last command duration.
#export BASH_IT_COMMAND_DURATION=true
# You can choose the minimum time in seconds before
# command duration is displayed.
#export COMMAND_DURATION_MIN_SECONDS=1

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

# Load Bash It
source "$BASH_IT"/bash_it.sh

# source ~/.bashrc

export PROMPT_COMMAND="${PROMPT_COMMAND/_pyenv_virtualenv_hook;/}"
export PS1="\[\e[0;36m\]\w\[\e[39m\] $ "

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
