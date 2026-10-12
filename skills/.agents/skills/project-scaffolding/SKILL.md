---
name: project-scaffolding
description: Use when starting a new project, investigation, or work item and the user names a target folder, when adding a work item to a project with _doctrine/, _work/, and code/ folders, or when bringing an existing folder into that lean, self-contained structure.
---

# Project Scaffolding

Lays down the same lean, self-contained base every time, then gets out of the way.
The base is a skeleton, not a finished-project layout.

Canonical invocation:

> Scaffold a new work item at `<path>` using the project-scaffolding skill. Interview me first (sources-first), then build the base.

## Pick the mode (read-only checks)

| What you find | Mode | Base |
|---------------|------|------|
| Target missing, empty, or only agent dot-folders (e.g. `.claude/`) | New project | Project layout |
| Target or a parent has `_doctrine/` | Work item | `<root>/_work/<YYYYMMDD_slug>/` in that project |
| Target has other content, no `_doctrine/` | Existing folder | Project layout added beside it; propose moves |
| User asks for a lone investigation, not a project | Standalone | Single-folder layout |

Say which mode you picked and why. If unclear, ask.

## What each mode creates (exactly this, nothing else)

**Project layout** (templates in `templates/project/`):

| Path | Role |
|------|------|
| `AGENTS.md` | Thin root entry point: layout, how we work, safety, workflow, doctrine index |
| `_doctrine/project.md` | Goal, shared understanding, non-goals, gates, context digest |
| `_doctrine/architecture.md` | Empty until a work item defines the code skeleton |
| `_doctrine/decisions.md` | Append-only decision log, seeded with the layout decision |
| `_doctrine/SOURCES.md`, `_doctrine/sources/` | Source index and durable copies, kept in doctrine because `_work/` is disposable |
| `_work/<YYYYMMDD>_<slug>/PLAN.md` | First work item (slug defaults to `kickoff`) |
| `code/.gitkeep` | The product goes here |

**Work item**: only `_work/<YYYYMMDD>_<slug>/PLAN.md`. New sources become rows in `_doctrine/SOURCES.md` and copies in `_doctrine/sources/`.

**Standalone**: `AGENTS.md` (from `templates/standalone/`), `SOURCES.md`, `sources/`, `PLAN.md` in the target.

`SOURCES.md` and `PLAN.md` always come from `templates/`. If the user gives a code workspace root, add a repo map (`_doctrine/workspace-repos.md`, or `references/workspace-repos.md` when standalone) in the format of `references/workspace-repos.md`, plus a pointer row for it.
No `README.md`, `notes/`, `findings.md`, logs, status boards, or checkpoints. Add heavier tracking only if the work grows into it.

## Rules

| Rule | In practice |
|------|-------------|
| Self-contained | Write only inside the target (the project root in work-item mode). Never write global agent config (e.g. `~/.claude`), memory, or anything outside. Reading outside is fine |
| Never overwrite | Create only missing files. Skip existing ones and report them |
| Lean entry point | `AGENTS.md` holds pointers. Context goes into the files it points to |
| `AGENTS.md`, never `CLAUDE.md` | Claude Code reads `AGENTS.md` only when no `CLAUDE.md` exists, so create just one. No symlink, no import file |
| Draft mutating shell commands | Write `mkdir`, `git init`, `git mv`, `cp`, commits and similar in a code block for the user to run. Read-only scans are fine. File writes use the file tool |
| Sources first, nothing dropped | Every pointer gets a `SOURCES.md` row, reachable or not. Always save a local copy when the content is readable |
| Every claim tagged | Each digest claim cites its `SOURCES.md` row, e.g. `[S2]` |
| No completion without evidence | A phase is ✅ only with a passing test, verified behavior, or a confirmed deploy |
| Generic | No company, team, repo, account, or tool names unless the user gave them |

## Steps

**1. Resolve the target (read-only).** Pick the mode. Check for git and for existing files. Check the target and every parent for `CLAUDE.md`, `.claude/CLAUDE.md`, or `CLAUDE.local.md`; if any exists, warn that Claude Code will read it instead of `AGENTS.md` (`~/.claude/CLAUDE.md` does not count). Draft what is missing:

```sh
mkdir -p <path>
git -C <path> init
```

**2. Kickoff interview (sources first).** One question per message, in this order. Skip any already answered, and in work-item mode skip what `_doctrine/` and `AGENTS.md` already settle (rows 2, 6, 7 usually).

| # | Ask for | Feeds |
|---|---------|-------|
| 1 | Pointers and context: doc links, wiki pages, PDF paths, chat threads, tickets, raw notes | `SOURCES.md`, ingestion |
| 2 | Project name and folder path; in project mode also the first work item slug | Titles, paths |
| 3 | A one-line goal. Propose one from the sources read so far; let the user correct it | `project.md` or `PLAN.md` |
| 4 | Relevant repos or systems, and the local workspace root if any. Don't assume | Repo map |
| 5 | Legal, compliance, security, or cross-team gates to flag up front | Gates |
| 6 | Environment safety: which environments are production, what the agent may never touch, data-handling limits (e.g. no PII) | `AGENTS.md` safety |
| 7 | Working preferences, coding standards, or workflow skills to invoke | `AGENTS.md` how we work |

After answer 1, read every reachable source (local files, and any doc, wiki, chat, or ticket connector available) so question 3 can propose a goal.
Don't ask whether to save copies or whether to use git; the rules already decide.

**3. Scan the workspace (read-only, only if a root was given).** One-line purpose per relevant repo, from its README or manifest.

**4. Build the base.** Only after the interview, and only once the target exists (wait for the user to run the drafted `mkdir`).
- Write each missing file from its template, replacing `<PLACEHOLDER>` tokens with interview answers and today's date. Leave a token in place when there is no answer yet.
- Save each readable source into `sources/` (e.g. `sources/S2-incident-notes.txt`) by reading it and writing the content with the file tool. Write `sources/.gitkeep` if nothing was saved.
- `SOURCES.md`: one row per pointer. Ingested: `✅ 🗄️` plus what we learned. Unreachable (auth required, no connector, no access): `📥 recorded, not yet ingested`, with the reason in "What it is".
- Context digest (`project.md` in project mode, else `PLAN.md`): tag every claim with its row, e.g. `- Retries tripled traffic after a timeout change [S1]`.
- If `SOURCES.md`, `PLAN.md`, or a doctrine file already exists, don't rewrite it. Show what you would append; append only after the user approves.
- Existing folder: propose where current content belongs (docs to `_doctrine/`, product to `code/`, `CLAUDE.md` to `AGENTS.md`) as drafted `git mv` commands. Never move anything yourself.

**5. Report and hand off.** Table of each path with `created`, `skipped (exists)`, or `proposed append`, then the drafted commands still to run, including a commit such as `git commit -m "Scaffold <PROJECT> workspace: doctrine, work, code"`. Start workflow step 1.

## The workflow it drives

1. Deep interview to reach a shared understanding, captured in `PLAN.md`.
2. Break the expectation into testable phases.
3. Implement one phase at a time, verifying each before moving on.
4. Close the loop by confirming the whole thing is testable end to end.

Work interactively and don't guess past ambiguity.

## Common mistakes

| Mistake | Instead |
|---------|---------|
| Inventing a layout (`README.md`, `notes/`, `findings.md`, a running log) | Exactly the files for the mode |
| Standalone files in a blank folder meant as a project | Project layout; standalone only when asked |
| Sources or copies inside `_work/` | `_doctrine/SOURCES.md` and `_doctrine/sources/` |
| A dozen questions in one message, or domain guesses (vendors, backends) | One question at a time, in the interview order |
| Listing unreachable links only in prose | A `📥` row in `SOURCES.md` for each |
| Running `mkdir`, `git init`, `git mv`, or `cp` | Draft them for the user; save copies with the file tool |
| Creating `CLAUDE.md` or a symlink to `AGENTS.md` | `AGENTS.md` only |
| Editing an existing doctrine file or `PLAN.md` directly | Propose the append, then wait for approval |
