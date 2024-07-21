###################
# ohmyzsh Configs #
###################

# Template is at https://github.com/ohmyzsh/ohmyzsh/blob/master/templates/zshrc.zsh-template

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Load plugins
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# source ohmyzsh
source $ZSH/oh-my-zsh.sh

######################
# User configuration #
######################

export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi


#############
# CLI Tools #
#############

# colorls
export PATH="$HOME/.gem/ruby/2.6.0/gems/colorls-1.4.6/exe:$PATH"
source $(dirname $(gem which colorls))/tab_complete.sh
alias ls="colorls"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# fzf
eval "$(fzf --zsh)"

# direnv
eval "$(direnv hook zsh)"

# starship
eval "$(starship init zsh)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# WezTerm
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

# OCaml
[[ ! -r '/Users/zhijiezhu/.opam/opam-init/init.zsh' ]] || source '/Users/zhijiezhu/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null

