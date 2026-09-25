# Configuration notes

Start with [README.md](README.md) for installation and updates.

## Tools

**zsh + oh-my-zsh + Powerlevel10k**, **Neovim + lazy.nvim**, **Herdr**, and
**Git**, plus **VS Code** settings, shortcuts, and extensions. Minimal **Vim** and **tmux** configurations are available for servers.
Neovim includes file/search pickers, shortcut hints, Git indicators, completion,
and language-server support for Python, TypeScript/JavaScript, Go, and Lua
(Pyright, TypeScript 7's native LSP, gopls, and Lua Language Server).
**Automic Vault** holds API credentials outside shell startup files.

## Shell prompt

The shared Powerlevel10k config preserves the original dark, two-line prompt
with a dotted connector, Git status, command duration, and clock. Keep your
terminal’s existing Nerd Font. Apply prompt changes to an open shell with
`source "$HOME/projects/dotfiles/zsh/.p10k.zsh"`, or open a new terminal.

## Existing installations

Stow targets your home directory and links individual files. On an existing
installation, run `stow -n -v zsh nvim git herdr vim vscode` first. Move conflicting
regular files to a private backup, removing any credentials from that backup;
remove old symlinks only after checking their destinations. Do not use
`stow --adopt`: it can bring private configuration into this public repository.
Remove any previous `~/.config/nvim/init.vim` after preserving the settings you
want; Neovim must have only one entry point.

Preserve personal Git overrides in `~/.gitconfig.local` before replacing
`~/.gitconfig`; the shared config includes that file last.

## Optional fallbacks

For the optional tmux fallback, run `stow tmux`. On a server, install just the
available tools and use `stow vim tmux`; the macOS Brewfile is not required there.
Herdr and tmux use Ctrl-A, then `v`/`s` to split and `h`/`j`/`k`/`l` to focus panes.
Herdr uses Ctrl-A Shift-R to reload and Ctrl-A comma for settings.

## Another Mac with private entry points

Clone at the same path and install the tools you need, but **do not Stow over files
owned by the private repository**. Source the shared shell config before private
additions:

```zsh
source "$HOME/projects/dotfiles/zsh/.zshrc"
# Private overrides follow here.
```

In a private Neovim init:

```lua
dofile(vim.env.HOME .. "/projects/dotfiles/nvim/.config/nvim/init.lua")
-- Private settings follow here.
```

In a private Git config, include the shared file before private overrides:

```gitconfig
[include]
    path = ~/projects/dotfiles/git/.gitconfig
```

Companion files resolve from the checkout, not from the private entry-point
directory. Source shell/editor entry points twice safely. To extend this Neovim
plugin set, set `vim.g.dotfiles_extra_plugins` before `dofile`; if the private init
already initialized lazy.nvim, it retains ownership of plugin setup.

## VS Code across Macs

The `vscode` package links the default macOS profile's `settings.json` and
`keybindings.json`. Your existing theme/formatting preferences are retained;
Python, Go, and Lua use their own formatters. The shortcuts file currently keeps
VS Code defaults. `dotfiles-code-extensions` installs missing shared extensions
without removing private ones; it also accepts `--profile NAME` and `--dry-run`.
Sign in to AI extensions on each machine; credentials are never copied here.

On the personal Mac, edit the shared files through VS Code or the repository.
Review changes before committing. On the work Mac, do not link writable editor
settings into the pull-only checkout. VS Code has no native settings include.
Keep **only private overrides** in a directory owned by the private repo, with
`settings.json` (an object, or `{}`) and `keybindings.json` (an array, or `[]`).
These two inputs must be strict JSON. Preserve any existing private preferences
in those inputs before the first render; output files are replaced.

```sh
# Set this to the directory of private override inputs on that machine.
VSCODE_PRIVATE="$HOME/.config/vscode-private"
"$HOME/projects/dotfiles/vscode/.local/bin/dotfiles-code-settings" \
  --overrides "$VSCODE_PRIVATE" \
  --output "$HOME/Library/Application Support/Code/User"
"$HOME/projects/dotfiles/vscode/.local/bin/dotfiles-code-extensions"
```

The renderer merges shared settings first, private settings last, and appends
private shortcuts after shared shortcuts. Repeat these commands after pulling.
It refuses to write into the shared checkout. Let this workflow own these files;
avoid also syncing the same settings through VS Code Settings Sync.

## API credentials

[Automic Vault](https://github.com/automic-vault/automic-vault) is optional and
installed separately: `brew install --cask automic-vault/isotopes/automic-vault`.
Open the app and complete its setup. The zsh config uses the app's bundled CLI
when no `av` command is installed; other shells can invoke
`/Applications/Automic Vault.app/Contents/MacOS/av` directly.

Use `av scan` to inspect findings, choose an appropriate supported hardener, then
verify it with `av doctor <tool>`. For a manual secret, `av save NAME` uses hidden
input. Prefer a supported hardener or reviewed script; for a one-off command,
`av inject +NAME -- command` scopes the credential to that process. Never export
vault values from `.zshrc`, paste values into commands, or put them in this repo.
Restart old shells to clear inherited exported tokens after migration. Rotate any
credential previously committed to Git; deleting it does not erase history.

Keep vault policy, credentials, and private tool configuration on each Mac.
Automic's gated launchers in `/usr/local/bin` take precedence when its CLI is
installed. This is an intentional exception to the normal Apple Silicon Brew
preference. **Do not harden Homebrew as part of this setup**: Automic's current
Homebrew hardener does not support `brew bundle`. Follow its documentation if you
choose to manage that separately.

## Updating machines with private entry points

```sh
cd "$HOME/projects/dotfiles"
git pull --ff-only
# Install newly required tools via your machine's approved setup process.
nvim --headless '+DotfilesInstall' '+Lazy! sync' +qa
```

Do not Stow there. Restart zsh and Neovim to load the updated shared files; update
private overrides only if the release calls out a compatibility change. For VS Code,
repeat the private-render and extension commands above, then reload its window. Resolve
local Git changes before pulling; do not discard them automatically.

## Reloading tools

Existing Stow links immediately reflect content changes; restowing handles added
and removed files. Open a fresh zsh and Neovim after updates. Reload the VS Code
window. Herdr reads configuration on restart, or use `herdr server reload-config`
for an existing server. Reload tmux with Ctrl-A `r`.

## Stable paths

Paths below are relative to the checkout. These are the integration contract;
future moves require an explicit migration note.

| Path | How to load |
| --- | --- |
| `zsh/.zshrc` | Source from an interactive zsh rc |
| `zsh/.p10k.zsh` | Source prompt settings from zsh |
| `zsh/.config/zsh/aliases.zsh` | Source aliases independently |
| `nvim/.config/nvim/init.lua` | `dofile` from a Neovim init (Neovim 0.11+) |
| `git/.gitconfig` | Git `[include]` |
| `vim/.vimrc` | Vim `:source` |
| `tmux/.tmux.conf` | tmux `source-file` |
| `herdr/.config/herdr/config.toml` | Herdr native config; no shell sourcing |
| `vscode/Library/Application Support/Code/User/settings.json` | VS Code settings / shared JSON input |
| `vscode/Library/Application Support/Code/User/keybindings.json` | VS Code shortcuts / shared JSON input |
| `vscode/.config/vscode/extensions.txt` | Shared extension IDs |

`git/.local/bin/git-reviewers` is an executable helper, not a sourceable config.
`vscode/.local/bin/dotfiles-code-extensions` and
`vscode/.local/bin/dotfiles-code-settings` are stable executable entry points.
Neovim's internal Lua modules and `plugin-lock.json` accompany its entry point.

## Migration notes

Bash, Screen, `rmb`, project/session launchers, the custom tmux status script, and
the legacy symlink installer were retired. Vim's editor preferences remain, while
the old plugin collection was replaced with Snacks, WhichKey, Gitsigns, Blink,
and Tokyo Night. No ctags/Tagbar, Python-dependent undo browser, Vundle/vim-plug,
Emmet, or EasyMotion setup remains. Core mappings use comma as leader: `,f` finds
files, `,fg` searches text, `,tr` opens the explorer, and `,h/j/k/l` changes windows.
Language servers provide `gd`, `gr`, `K`, F2, and `,ca`; Go formats on save.

Verification: `python3 tests/verify.py` checks isolated configuration loading and
helpers; add `--lsp` to check all four language servers with the Brewfile installed.
