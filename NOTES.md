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

## Terminal appearance

The `ghostty` package preserves the existing Ghostty defaults explicitly: bundled
JetBrains Mono at 13pt, dark background/palette, and the default block cursor
(shell integration may switch it to a bar at the prompt). No font download is needed.
Cmd-D splits right, Cmd-Shift-D splits down, Cmd-[ / Cmd-] moves between splits,
and Cmd-Shift-comma reloads config. The restored Powerlevel10k prompt is unchanged.
See [Ghostty configuration](https://ghostty.org/docs/config).

Ghostty loads `~/.config/ghostty/config.ghostty`, then macOS Application Support
configuration, so existing settings in the latter can override this package.
On a private machine, use Ghostty's `config-file` directive to load the shared
file by path, then another private file **as a second `config-file` directive**.
Includes run after the containing file; private settings written below an include
in the same file do not override it. Use paths relative to that private config,
or generate absolute paths from `$HOME` during private setup. Do not put machine
paths into this public checkout.

## Git ignores and secret scanning

Git automatically reads `~/.config/git/ignore` when `core.excludesFile` and
`XDG_CONFIG_HOME` do not select another location. It excludes OS/editor litter and
machine-local assistant settings. Project build outputs and dependency directories
belong in each project's `.gitignore`; example environment files remain visible.
If a private machine already owns its global ignore file, copy these patterns into
that file or point its `core.excludesFile` at this checkout's shared ignore file.
Preserve any existing private patterns when combining them.

`dotfiles-secrets install` installs a [Gitleaks](https://github.com/gitleaks/gitleaks)
pre-commit hook **only in the current repository**. Run it once in each personal
repo you want protected. It refuses to replace an existing hook or `core.hooksPath`;
add `dotfiles-secrets check` to your existing hook manager instead. On a pull-only
machine, invoke `git/.local/bin/dotfiles-secrets` by its full checkout path.

The hook checks staged changes, including partially staged files, with secret
values redacted. Missing Gitleaks or a finding blocks the commit. It does not scan
old commits or local backup refs. Repository-specific Gitleaks rules and ignores
still apply; review exceptions carefully. Hooks can be bypassed, so this does not
replace provider rotation or server-side push protection. To uninstall our hook,
remove only the `pre-commit` symlink pointing to this helper; leave other hooks alone.

## Checking a machine

Run `dotfiles-doctor` after setup or an update. It checks dependencies, expected
Stow links, shared shell syntax, isolated Neovim startup, plugin installation,
Ghostty config validity, and shared VS Code extensions. It makes no repairs,
does not load private shell/editor startup files, and never requests vault tokens.
Use `--packages git nvim` for a subset, or add `tmux` to the package list.
Failures return a nonzero exit code; resolve them with the normal setup steps.

On a private machine run
`"$HOME/projects/dotfiles/doctor/.local/bin/dotfiles-doctor" --private`.
This skips Stow ownership checks; private overrides still need their own validation.

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

## Shared snippets

Neovim and VS Code share ten small snippets for Python, JavaScript/TypeScript
(including React files), Go, and Lua. Type `dfmain`, `dftest`, `dfasync`, `dffn`,
`dftype`, `dferr`, or `dfmodule` in the applicable language and select completion.
In VS Code they are also available through Insert Snippet; Blink uses Tab/Shift-Tab
to navigate placeholders. Snippets are starting points; add required imports
(such as Go's `testing`) and project-specific types.

The canonical files are `vscode/Library/Application Support/Code/User/snippets/`;
Neovim loads them by path through its snippet manifest. No new plugin is needed.
The private VS Code renderer refreshes only `dotfiles-*.code-snippets`, preserving
other snippet files. Reserve that filename prefix for shared files; keep private
snippets in separately named files. Personal Neovim snippets can use
`~/.config/nvim/snippets/*.json` (VS Code snippet syntax).

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
| `vscode/Library/Application Support/Code/User/snippets/` | Shared VS Code-format snippets |
| `ghostty/.config/ghostty/config.ghostty` | Ghostty `config-file` include |
| `git/.config/git/ignore` | Git global exclusion patterns |

`git/.local/bin/git-reviewers` is an executable helper, not a sourceable config.
`vscode/.local/bin/dotfiles-code-extensions` and
`vscode/.local/bin/dotfiles-code-settings` are stable executable entry points.
Neovim's internal Lua modules and `plugin-lock.json` accompany its entry point.
`git/.local/bin/dotfiles-secrets` and `doctor/.local/bin/dotfiles-doctor` are stable
executable entry points.

## Migration notes

Shared shell startup uses Emacs keybindings, preserves existing `GOPATH`/`GOBIN`,
and initializes zoxide, thefuck, and Bun completions when available. The standalone
aliases file provides `b64e`/`b64d` for base64, `aliasf` to list functions, and
`ge` for an empty build-trigger commit when Git is installed.

The Brewfile uses `claude-code@latest`. If a Mac still has the conflicting
`claude-code` cask, run `brew uninstall --cask claude-code` before
`brew bundle --no-upgrade` to switch channels.

Bash, Screen, `rmb`, project/session launchers, the custom tmux status script, and
the legacy symlink installer were retired. Vim's editor preferences remain, while
the old plugin collection was replaced with Snacks, WhichKey, Gitsigns, Blink,
and Tokyo Night. No ctags/Tagbar, Python-dependent undo browser, Vundle/vim-plug,
Emmet, or EasyMotion setup remains. Core mappings use comma as leader: `,f` finds
files, `,fg` searches text, `,tr` opens the explorer, and `,h/j/k/l` changes windows.
Language servers provide `gd`, `gr`, `K`, F2, and `,ca`; Go formats on save.

Verification: `python3 tests/verify.py` checks isolated configuration loading and
helpers; add `--lsp` to check all four language servers with the Brewfile installed.
`python3 tests/additions.py` checks hook refusal, redacted staged-secret blocking,
partial staging, global ignores, shared snippet inputs, and doctor behavior.

## Agent instructions

Shared preferences live at the stable path `agents/.config/agents/common.md`.
Codex's stable entry point is `codex/.codex/AGENTS.md`; Claude's is `claude/.claude/CLAUDE.md`.
The Codex entry is a symlink to the shared file, so the rules have only one source.
Claude imports that file and optional private instructions from `~/.claude/CLAUDE.local.md`.

On a personal Mac, preserve any existing instructions before installing:

```sh
stow -n -v agents codex claude
stow agents codex claude
```

If `~/.claude/CLAUDE.md` already exists, move its contents into `~/.claude/CLAUDE.local.md` first, preserving any existing local file.
Keep local instructions private.
If Codex already has global instructions, combine them with these preferences using the private-machine approach below instead of replacing them.
A non-empty `~/.codex/AGENTS.override.md` takes precedence over `AGENTS.md`; review it if the shared rules do not load.
A custom `CODEX_HOME` needs its entry point installed there instead.

On a private machine, let the private repo own the entry points.
Claude can import `@~/projects/dotfiles/agents/.config/agents/common.md` from its private `~/.claude/CLAUDE.md`, followed by private rules.
For Codex, combine the shared file followed by private rules into `~/.codex/AGENTS.md` as part of the private repo's setup process.
Codex does not use Claude's `@` import syntax.
Regenerate that combined file after pulling changes; direct Stow links and Claude imports see updates automatically.
Keep each project's build commands and conventions in its own `AGENTS.md`.

Start a new agent session after updates.
Ask Codex to summarize its loaded instructions; use Claude's `/memory` to inspect loaded files.
These files contain preferences only, not credentials, tool permissions, or automatic memories.
