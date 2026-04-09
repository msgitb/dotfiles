# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle :compinstall filename '/home/marcelo/.zshrc'

autoload -Uz compinit
if [[ -n "${ZDOTDIR:-$HOME}/.zcompdump"(#qN.mh+24) ]]; then
  compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"
else
  compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump"
fi
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
export HISTFILE=~/.zsh_history
export HSTR_CONFIG=hicolor,show-skipped-commands,prompt-bottom,raw-history-view
export HISTSIZE=50000
export SAVEHIST=50000
setopt autocd beep extendedglob histignorealldups sharehistory
bindkey -e
# End of lines configured by zsh-newuser-install
#PROMPT='%n@%m %~ %# '

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Plugins
zinit light Aloxaf/fzf-tab
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting


# Aliases
alias ls='eza --icons'
alias ll='eza -la --icons'
alias cat='batcat'
alias hh='hstr'
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# Lazy load nvm
export NVM_DIR="$HOME/.nvm"
nvm() {
    unfunction nvm
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
    nvm "$@"
}
node() {
    unfunction node
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    node "$@"
}
npm() {
    unfunction npm
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    npm "$@"
}

#py env settings
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"

#variables
export GITHUB_USERNAME="msgitb"

# Starship prompt (must be last)
eval "$(starship init zsh)"
export PATH="$HOME/.local/bin:$PATH"
