# dotfiles

macOS setup with Stow: Ghostty, zsh + Powerlevel10k, Neovim, Herdr, Git, and VS Code.

## Initial setup

Install [Homebrew](https://brew.sh), then:

```sh
git clone https://github.com/khanduri/dotfiles.git "$HOME/projects/dotfiles"
cd "$HOME/projects/dotfiles"
brew bundle && stow zsh nvim git herdr vim vscode ghostty doctor
# Skip this clone if oh-my-zsh is already installed.
git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
zsh -il
nvim --headless '+DotfilesInstall' +qa
dotfiles-code-extensions
dotfiles-secrets install
dotfiles-doctor
git config --file "$HOME/.gitconfig.local" user.name "Your Name"
git config --file "$HOME/.gitconfig.local" user.email "your-address@example.com"
```

Already have config files? [Back them up before Stowing](NOTES.md#existing-installations).
For a Mac with private entry points, [follow these instructions](NOTES.md#another-mac-with-private-entry-points)
instead of Stowing. Keep credentials out of this repo; see [Automic Vault setup](NOTES.md#api-credentials).

Open a fresh terminal, run `nvim` or `herdr`, or launch VS Code. Optional tmux
fallback: `stow tmux`.

## Update

On a Mac using Stow:

```sh
cd "$HOME/projects/dotfiles"
git pull --ff-only
brew bundle
stow -n -v -R zsh nvim git herdr vim vscode ghostty doctor
# Review the dry run above, then apply:
stow -R zsh nvim git herdr vim vscode ghostty doctor
nvim --headless '+DotfilesInstall' '+Lazy! sync' +qa
dotfiles-code-extensions
dotfiles-doctor
```

Include `tmux` in both Stow commands if installed. Restart your shell and editors;
[reload Herdr/tmux](NOTES.md#reloading-tools) for existing sessions.
On a Mac with private entry points, [pull and apply using its private setup](NOTES.md#updating-machines-with-private-entry-points).

## Stable paths

Sourceable paths are a contract; moves will be called out:

- zsh: `zsh/.zshrc`, `zsh/.p10k.zsh`, `zsh/.config/zsh/aliases.zsh`
- Neovim: `nvim/.config/nvim/init.lua`
- Git: `git/.gitconfig`
- Vim/tmux: `vim/.vimrc`, `tmux/.tmux.conf`

See [NOTES.md](NOTES.md) for all stable paths, private overrides, VS Code setup,
vault usage, and migration details.
