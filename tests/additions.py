#!/usr/bin/env python3
"""Exercise hook protection and index scanning without storing a real credential."""
import json
import os
from pathlib import Path
import secrets
import string
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
HOOK = ROOT / "git/.local/bin/dotfiles-secrets"

with tempfile.TemporaryDirectory(prefix="dotfiles-additions-") as temporary:
    home = Path(temporary)
    repo = home / "repo"
    repo.mkdir()
    env = {"HOME": str(home), "PATH": os.environ["PATH"], "GIT_CONFIG_NOSYSTEM": "1",
           "GIT_AUTHOR_NAME": "Example", "GIT_AUTHOR_EMAIL": "example@example.invalid",
           "GIT_COMMITTER_NAME": "Example", "GIT_COMMITTER_EMAIL": "example@example.invalid"}

    def run(*command):
        return subprocess.run(command, cwd=repo, env=env, capture_output=True, text=True)

    assert run("git", "init", "-q").returncode == 0
    assert run(str(HOOK), "install").returncode == 0
    assert run(str(HOOK), "install").returncode == 0
    target = repo / ".git/hooks/pre-commit"
    target.unlink()
    target.write_text("#!/bin/sh\nexit 0\n")
    assert run(str(HOOK), "install").returncode != 0
    assert target.read_text() == "#!/bin/sh\nexit 0\n"
    target.unlink()
    assert run("git", "config", "core.hooksPath", ".private-hooks").returncode == 0
    assert run(str(HOOK), "install").returncode != 0
    assert run("git", "config", "--unset", "core.hooksPath").returncode == 0
    assert run(str(HOOK), "install").returncode == 0
    print("PASS: repeat hook install; existing hooks and hook manager retained")

    file = repo / "fixture.txt"
    file.write_text("ordinary content\n")
    assert run("git", "add", "fixture.txt").returncode == 0
    assert run("git", "commit", "-qm", "clean initial commit").returncode == 0
    # Synthetic random fixture, never used as a credential or written to this repo.
    token = "gh" + "p_" + "".join(secrets.choice(string.ascii_letters + string.digits) for _ in range(36))
    file.write_text("token = " + token + "\n")
    assert run("git", "add", "fixture.txt").returncode == 0
    file.write_text("sanitized working tree\n")
    result = run("git", "commit", "-qm", "must be blocked")
    assert result.returncode != 0
    assert token not in result.stdout + result.stderr
    assert "leaks" in result.stderr.lower()
    assert run("git", "add", "fixture.txt").returncode == 0
    file.write_text("token = " + token + "\n")
    assert run("git", "commit", "-qm", "clean staged change").returncode == 0
    print("PASS: staged secret blocked and redacted; clean partial staging allowed")

    ignore = ROOT / "git/.config/git/ignore"
    for filename in (".DS_Store", "sample.swp", ".claude/settings.local.json"):
        assert run("git", "-c", "core.excludesFile=" + str(ignore), "check-ignore", filename).returncode == 0
    assert run("git", "-c", "core.excludesFile=" + str(ignore), "check-ignore", ".env.example").returncode == 1
    print("PASS: global ignores preserve project-owned example files")

    # A private renderer retains unrelated private snippets while refreshing our files.
    private = home / "private"
    output = home / "output"
    private.mkdir()
    (private / "settings.json").write_text("{}")
    (private / "keybindings.json").write_text("[]")
    (output / "snippets").mkdir(parents=True)
    (output / "snippets/private.code-snippets").write_text("{}")
    renderer = ROOT / "vscode/.local/bin/dotfiles-code-settings"
    assert run(str(renderer), "--overrides", str(private), "--output", str(output)).returncode == 0
    assert (output / "snippets/private.code-snippets").read_text() == "{}"
    assert len(list((output / "snippets").glob("dotfiles-*.code-snippets"))) == 5
    manifest = ROOT / "nvim/.config/nvim/dotfiles-snippets/package.json"
    for entry in json.loads(manifest.read_text())["contributes"]["snippets"]:
        snippets = json.loads((manifest.parent / entry["path"]).read_text())
        assert snippets
        assert all(s["prefix"].startswith("df") and s["body"] for s in snippets.values())
    print("PASS: snippets share one source; private snippets retained")

    # Missing links are failures, while private mode skips links explicitly.
    doctor = ROOT / "doctor/.local/bin/dotfiles-doctor"
    assert run(str(doctor), "--packages", "git").returncode != 0
    assert run(str(doctor), "--private", "--packages", "git").returncode == 0
    print("PASS: doctor detects absent links and supports private entry points")
