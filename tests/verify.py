#!/usr/bin/env python3
"""Isolated integration checks; never load the user's private startup files."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def run(args, *, env, cwd=ROOT):
    result = subprocess.run(args, env=env, cwd=cwd, text=True, capture_output=True)
    if result.returncode:
        raise AssertionError(f'{args[0]} failed:\n{result.stdout}\n{result.stderr}')
    return result.stdout


with tempfile.TemporaryDirectory(prefix='dotfiles-check-') as directory:
    home = Path(directory)
    env = {'HOME': str(home), 'PATH': os.environ['PATH'], 'TERM': 'xterm-256color',
           'XDG_CONFIG_HOME': str(home/'config'), 'XDG_DATA_HOME': str(home/'data'),
           'XDG_STATE_HOME': str(home/'state'), 'XDG_CACHE_HOME': str(home/'cache')}
    # Source from a caller-owned entry point, with neither Stow nor frameworks.
    (home/'.zshrc').write_text('source "$DOTFILES_TEST_ROOT/zsh/.zshrc"\n')
    shell_env = dict(env, DOTFILES_TEST_ROOT=str(ROOT), ZDOTDIR=str(home),
                     ZSH=str(home/'missing-oh-my-zsh'), PATH='/usr/bin:/bin')
    shell_test = '''
source "$DOTFILES_TEST_ROOT/zsh/.zshrc"
first_path=$PATH
first_pwd=$PWD
source "$DOTFILES_TEST_ROOT/zsh/.zshrc"
source "$DOTFILES_TEST_ROOT/zsh/.config/zsh/aliases.zsh"
[[ $PATH == $first_path && $PWD == $first_pwd ]] || exit 1
[[ $EDITOR == nvim ]] || exit 1
(( $+aliases[g] )) || exit 1
(( ! $+functions[rmb] )) || exit 1
print SHELL_OK
'''
    # Disable the optional prompt daemon for the non-TTY test subprocess.
    shell_env['POWERLEVEL9K_DISABLE_GITSTATUS'] = 'true'
    assert 'SHELL_OK' in run(['/bin/zsh', '-dic', shell_test], env=shell_env)
    print('PASS: shell composition and repeat sourcing')

    fixture = home/'history'
    fixture.mkdir()
    git_env = dict(env, GIT_CONFIG_NOSYSTEM='1', GIT_AUTHOR_NAME='Example Author',
                   GIT_AUTHOR_EMAIL='author@example.invalid', GIT_COMMITTER_NAME='Example Author',
                   GIT_COMMITTER_EMAIL='author@example.invalid')
    def git(*args): return run(['git', *args], env=git_env, cwd=fixture)
    git('init', '-q')
    file = fixture/'file with spaces.txt'
    file.write_text('first\nsecond\nthird\n')
    git('add', '--', file.name)
    git('commit', '-qm', 'initial')
    file.write_text('first changed\nthird\n')
    git('commit', '-qam', 'change and deletion')
    helper = str(ROOT/'git/.local/bin/git-reviewers')
    out = run([helper, 'HEAD'], env=git_env, cwd=fixture)
    assert '2 Example Author <author@example.invalid>' in out, out
    assert run([helper, 'HEAD', 'HEAD^'], env=git_env, cwd=fixture) == out
    bad = subprocess.run([helper, '--invalid'], env=git_env, cwd=fixture, capture_output=True)
    assert bad.returncode != 0
    print('PASS: reviewer attribution, spaced paths, explicit range, invalid ref')

    # A private Lua init loads the entry by path twice, without changing cwd or
    # resetting later private overrides. No plugins are installed in this HOME.
    nvim = shutil.which('nvim')
    entry = str(ROOT/'nvim/.config/nvim/init.lua')
    init = home/'private.lua'
    init.write_text(f'''local entry = {json.dumps(entry)}
local cwd = vim.fn.getcwd()
dofile(entry)
local count = #vim.api.nvim_get_autocmds({{ group = "DotfilesEditing" }})
vim.opt.shiftwidth = 7
dofile(entry)
assert(vim.o.shiftwidth == 7)
assert(vim.fn.getcwd() == cwd)
assert(#vim.api.nvim_get_autocmds({{ group = "DotfilesEditing" }}) == count)
vim.cmd("edit " .. vim.fn.fnameescape({json.dumps(str(home/'sample.md'))}))
vim.bo.filetype = "markdown"
vim.api.nvim_buf_set_lines(0, 0, -1, false, {{ "hard break  " }})
vim.cmd.write()
assert(vim.fn.readfile({json.dumps(str(home/'sample.md'))})[1] == "hard break  ")
vim.cmd("edit " .. vim.fn.fnameescape({json.dumps(str(home/'sample.txt'))}))
vim.api.nvim_buf_set_lines(0, 0, -1, false, {{ "trim me  " }})
vim.cmd.write()
assert(vim.fn.readfile({json.dumps(str(home/'sample.txt'))})[1] == "trim me")
assert(vim.v.errmsg == "", vim.v.errmsg)
''')
    run([nvim, '--headless', '-u', str(init), '+lua if vim.v.errmsg ~= "" then vim.cmd("cquit 1") end', '+qa'], env=env)
    print('PASS: private Neovim entry, repeat sourcing, overrides, whitespace semantics')
    run(['vim', '-Nu', str(ROOT/'vim/.vimrc'), '-n', '-es',
         '+source '+str(ROOT/'vim/.vimrc'), '+qa'], env=env)
    print('PASS: plugin-free Vim fallback')

    private = home/'vscode-private'
    output = home/'vscode-user'
    private.mkdir()
    (private/'settings.json').write_text(json.dumps({'editor.fontSize': 15, '[python]': {'editor.formatOnSave': False}}))
    (private/'keybindings.json').write_text(json.dumps([{'key': 'cmd+alt+t', 'command': 'workbench.action.terminal.toggleTerminal'}]))
    renderer = str(ROOT/'vscode/.local/bin/dotfiles-code-settings')
    command = [renderer, '--overrides', str(private), '--output', str(output)]
    run(command, env=env)
    settings = json.loads((output/'settings.json').read_text())
    assert settings['editor.fontSize'] == 15
    assert settings['[python]']['editor.defaultFormatter'] == 'charliermarsh.ruff'
    assert settings['[python]']['editor.formatOnSave'] is False
    assert len(json.loads((output/'keybindings.json').read_text())) == 1
    before = (output/'settings.json').read_bytes()
    run(command, env=env)
    assert (output/'settings.json').read_bytes() == before
    shared = ROOT/'vscode/Library/Application Support/Code/User'
    refused = subprocess.run([renderer, '--overrides', str(private), '--output', str(shared)],
                             env=env, capture_output=True)
    assert refused.returncode != 0
    assert 'editor.fontSize' not in json.loads((shared/'settings.json').read_text())
    print('PASS: VS Code private overrides, repeat rendering, checkout write protection')

    if '--lsp' in __import__('sys').argv:
        project = home/'languages'
        project.mkdir()
        fixtures = {
            'sample.py': 'answer = 42\nprint(answer)\n',
            'sample.ts': 'const answer: number = 42;\nconsole.log(answer);\n',
            'sample.js': 'const answer = 42;\nconsole.log(answer);\n',
            'main.go': 'package main\nfunc main() {}\n',
            'sample.lua': 'local answer = 42\nprint(answer)\n',
            'pyproject.toml': '', 'package.json': '{"private":true}',
            'tsconfig.json': '{"compilerOptions":{"allowJs":true}}',
            'go.mod': 'module example.invalid/check\n\ngo 1.23\n', '.luarc.json': '{}',
        }
        for name, value in fixtures.items(): (project/name).write_text(value)
        check = home/'lsp-check.lua'
        check.write_text('''local ok, err = pcall(function()
local cases = { {"sample.py", "pyright"}, {"sample.ts", "tsc"}, {"sample.js", "tsc"}, {"main.go", "gopls"}, {"sample.lua", "lua_ls"} }
for _, case in ipairs(cases) do
  vim.cmd("edit " .. case[1])
  local buf = vim.api.nvim_get_current_buf()
  assert(vim.wait(20000, function()
    local clients = vim.lsp.get_clients({bufnr=buf, name=case[2]})
    return #clients > 0 and clients[1].initialized
  end, 100), "LSP failed: " .. case[2])
  print("PASS LSP " .. case[1] .. " / " .. case[2])
end
assert(vim.v.errmsg == "", vim.v.errmsg)
end)
if not ok then print(err); vim.cmd("cquit 1") else vim.cmd("qa!") end
''')
        result = subprocess.run([nvim, '--headless', '-u', entry, '-c', 'luafile '+str(check)],
                                cwd=project, env=env, capture_output=True, text=True, timeout=110)
        print(result.stdout + result.stderr)
        assert result.returncode == 0, 'Language server integration failed'
