# Public entry point: safe to source by path from a private .zshrc.
[[ -o interactive ]] || return 0
(( ${+_DOTFILES_ZSH_LOADED} )) && return 0
typeset -g _DOTFILES_ZSH_LOADED=1
typeset -g _DOTFILES_ZSH_DIR=${${(%):-%x}:A:h}

# Detect the installation prefix without invoking Homebrew at shell startup.
typeset -U path fpath
if [[ -x /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX=/opt/homebrew
elif [[ -x /usr/local/bin/brew ]]; then
  export HOMEBREW_PREFIX=/usr/local
fi
if [[ -n ${HOMEBREW_PREFIX:-} ]]; then
  path=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" $path)
fi
path+=("$HOME/.local/bin" "$HOME/go/bin")
# Automic installs its gated launchers here. Keep them ahead of upstream tools.
[[ -x /usr/local/bin/av ]] && path=(/usr/local/bin $path)
[[ -d $HOME/.bun/bin ]] && path+=("$HOME/.bun/bin")
export PATH

# The app's bundled CLI works before its optional system launcher is installed.
if ! command -v av >/dev/null 2>&1 && [[ -x '/Applications/Automic Vault.app/Contents/MacOS/av' ]]; then
  av() { '/Applications/Automic Vault.app/Contents/MacOS/av' "$@"; }
fi

HISTFILE=${HISTFILE:-$HOME/.zsh_history}
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
command -v nvim >/dev/null 2>&1 && export EDITOR=nvim VISUAL=nvim

export ZSH=${ZSH:-$HOME/.oh-my-zsh}
ZSH_THEME=""
# Our aliases keep their original meanings instead of loading OMZ's git aliases.
plugins=()
zstyle ':omz:update' mode disabled
if [[ -r $ZSH/oh-my-zsh.sh ]] && (( ! $+functions[omz] )); then
  source "$ZSH/oh-my-zsh.sh"
fi
[[ -r $_DOTFILES_ZSH_DIR/.config/zsh/aliases.zsh ]] && source "$_DOTFILES_ZSH_DIR/.config/zsh/aliases.zsh"

if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT=${PYENV_ROOT:-$HOME/.pyenv}
  eval "$(pyenv init - zsh)"
fi
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if [[ -r ${HOMEBREW_PREFIX:-}/share/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
elif [[ -r $ZSH/custom/themes/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source "$ZSH/custom/themes/powerlevel10k/powerlevel10k.zsh-theme"
fi
[[ -r $_DOTFILES_ZSH_DIR/.p10k.zsh ]] && source "$_DOTFILES_ZSH_DIR/.p10k.zsh"
return 0
