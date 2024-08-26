# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

###################
# ohmyzsh Configs #
###################

# Template is at https://github.com/ohmyzsh/ohmyzsh/blob/master/templates/zshrc.zsh-template

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

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
  export EDITOR='vim'
fi


#############
# CLI Tools #
#############

# colorls
export PATH="$HOME/.gem/ruby/2.6.0/gems/colorls-1.4.6/exe:$PATH"
source $(dirname $(gem which colorls))/tab_complete.sh
alias ls="colorls"

# fzf
eval "$(fzf --zsh)"

# starship
# eval "$(starship init zsh)"

# WezTerm
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

# OCaml
[[ ! -r '/Users/zhijiezhu/.opam/opam-init/init.zsh' ]] || source '/Users/zhijiezhu/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
