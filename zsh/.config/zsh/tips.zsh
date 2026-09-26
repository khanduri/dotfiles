# Local tips only: never execute a suggested command or inspect shell history.
dotfiles-tip() {
  emulate -L zsh
  local requested=${1:-} entry tool message
  local -a tips available topics
  if (( $# > 1 )) || [[ $requested == --help ]]; then
    print -r -- 'Usage: dotfiles-tip [tool | --list]'
    return 0
  fi
  tips=(
    'zsh|Ctrl-A and Ctrl-E move to the start and end of your command line.'
    'zsh|Alt-B and Alt-F move backward and forward by one word.'
    'zsh|Ctrl-U clears back to the start of the command line; Ctrl-Y restores it.'
    'git|Try `git diff --word-diff` to see changes within lines.'
    'git|Try `git diff --cached` to review exactly what your next commit includes.'
    'git|Try `git log --oneline --graph --all` to see how your branches connect.'
    'nvim|In Normal mode, `ciw` replaces the word under your cursor.'
    'nvim|In Normal mode, `gv` reselects your previous Visual selection.'
    'nvim|Use `:help text-objects` to learn targets such as words, quotes, and parentheses.'
    'nvim|In Normal mode, `g;` jumps to an earlier change in the current file.'
    'zoxide|After visiting a folder, use `z name` to jump back by part of its path.'
    'zoxide|Try `zoxide query --list` to see directories zoxide remembers.'
    'thefuck|After a failed command, type `fuck`; review the correction, then press Enter.'
    'thefuck|At a correction prompt, use the arrow keys for alternatives or Ctrl-C to cancel.'
    'fzf|Press Ctrl-R to search command history, then Enter to put a match on your command line.'
    'fzf|Press Ctrl-T to pick a file path and insert it into your command line.'
    'rg|Try `rg -n TODO .` to find TODOs with line numbers.'
    'rg|Try `rg -l TODO .` when you only need the names of matching files.'
    'fd|Try `fd -e py` to find Python files below the current directory.'
    'fd|Try `fd -H pattern` to include hidden files in a filename search.'
    'uv|Inside a uv project, `uv tree` shows the dependency tree.'
    'uv|Use `uv run script.py` to run a script in the project environment.'
    'python3|Use `python3 -m json.tool file.json` to validate and pretty-print JSON.'
    'node|Use `node --check file.js` to check JavaScript syntax without running the file.'
    'go|Use `go test ./...` to test all packages below the current module directory.'
    'gh|Inside a GitHub checkout, `gh pr status` summarizes pull requests relevant to you.'
    'gh|Use `gh pr checks` to see CI status for the current branch pull request.'
    'bun|Use `bun run` to list the scripts available in the current package.json.'
    'tmux|Use `tmux list-keys` to inspect the keybindings actually loaded in your session.'
    'stow|Use `stow -n -v zsh` from this repo to preview shell symlinks without changing them.'
    'brew|Use `brew leaves` to list installed formulas that no other installed formula depends on.'
    'brew|Use `brew bundle check --no-upgrade` in this repo to find missing setup packages.'
    'gitleaks|Use `gitleaks git --help` to explore options for scanning Git history for secrets.'
    'herdr|Use `herdr --help` to discover the commands supported by your installed version.'
    'claude|Use `claude --help` to explore the options supported by your installed Claude Code.'
    'codex|Use `codex --help` to explore the options supported by your installed Codex CLI.'
    'pyenv|Use `pyenv versions` to list Python versions managed by pyenv.'
    'ruff|Use `ruff check .` to report Python lint issues without applying fixes.'
    'docker|Use `docker compose config --services` to list services in a Compose project.'
    'code|In VS Code, Cmd-P opens a file by name; Cmd-Shift-P opens the command palette.'
    'ghostty|In the shared Ghostty setup, Cmd-D splits right and Cmd-Shift-D splits down.'
    'rectangle|Open the Rectangle menu to review or customize your window-management shortcuts.'
    'opensuperwhisper|Open OpenSuperWhisper settings to review your recording shortcut.'
  )
  command -v fzf >/dev/null 2>&1 && tips+=('zoxide|Try `zi` to interactively pick a directory you have visited.')
  for entry in "${tips[@]}"; do
    tool=${entry%%|*}
    [[ -z $requested || $requested == --list || $requested == $tool ]] || continue
    case $tool in
      rectangle) [[ -d /Applications/Rectangle.app || -d $HOME/Applications/Rectangle.app ]] || continue ;;
      opensuperwhisper) [[ -d /Applications/OpenSuperWhisper.app || -d $HOME/Applications/OpenSuperWhisper.app ]] || continue ;;
      ghostty) command -v ghostty >/dev/null 2>&1 || [[ -d /Applications/Ghostty.app || -d $HOME/Applications/Ghostty.app ]] || continue ;;
      code) command -v code >/dev/null 2>&1 || [[ -d /Applications/Visual\ Studio\ Code.app || -d $HOME/Applications/Visual\ Studio\ Code.app ]] || continue ;;
      *) command -v "$tool" >/dev/null 2>&1 || continue ;;
    esac
    available+=("$entry")
    topics+=("$tool")
  done
  if [[ $requested == --list ]]; then
    (( ${#topics} )) && print -rl -- "${(@ou)topics}"
    return 0
  fi
  if (( ! ${#available} )); then
    [[ -n $requested ]] && print -ru2 -- "No tips for installed tool: $requested (try dotfiles-tip --list)"
    return 1
  fi
  entry=${available[RANDOM % ${#available} + 1]}
  tool=${entry%%|*}
  message=${entry#*|}
  print -r -- "Tip [$tool]: $message"
}

# Wait for the first real prompt, after private configuration has also loaded.
# Removing this hook before printing keeps subsequent prompts quiet.
_dotfiles_startup_tip() {
  emulate -L zsh
  add-zsh-hook -d precmd _dotfiles_startup_tip
  [[ ${DOTFILES_TIPS:-1} != 0 && -t 0 && -t 1 && $TERM != dumb ]] || return 0
  dotfiles-tip || true
}

if [[ -o interactive && -z ${ZSH_EXECUTION_STRING:-} ]]; then
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _dotfiles_startup_tip
fi
