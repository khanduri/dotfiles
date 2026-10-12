---
name: project-scaffolding
description: Use when starting a new project, investigation, or work item and the user names a target folder, or when bringing an existing work folder into a lean, self-contained structure.
---

# Project Scaffolding

Lays down the same lean, self-contained base for every work item, then gets out of the way.
The base is a skeleton, not a finished-project layout.

Canonical invocation:

> Scaffold a new work item at `<path>` using the project-scaffolding skill. Interview me first (sources-first), then build the base.

## What it creates (exactly this, nothing else)

| Path | Role |
|------|------|
| `AGENTS.md` | Short entry point read at the start of every session: pointers, how we work, safety rules, the workflow |
| `SOURCES.md` | Living index of every doc, link, PDF, or thread, with its type, ingest status, and what we learned |
| `sources/` | Durable local copies of source material |
| `PLAN.md` | Shared understanding, testable phases, and status for each phase |
| `references/workspace-repos.md` | Relevant local repos, one-line purpose each. Only if the user has a code workspace |

Build each file from this skill's `templates/` (and `references/workspace-repos.md` for the repo map format).
No `README.md`, `notes/`, `findings.md`, logs, status boards, or checkpoints. Add heavier tracking later, only if the work item grows into needing it.

## Rules

| Rule | In practice |
|------|-------------|
| Self-contained | Write only inside the target folder. Never write global agent config (e.g. `~/.claude`), memory, or anything outside it. Reading outside is fine |
| Never overwrite | Create only missing files. Skip existing ones and report them |
| Lean entry point | `AGENTS.md` holds pointers. Context goes into `SOURCES.md`, `PLAN.md`, and `sources/` |
| `AGENTS.md`, never `CLAUDE.md` | Claude Code reads `AGENTS.md` only when no `CLAUDE.md` exists, so create just one. No symlink, no import file |
| Draft mutating shell commands | Write `mkdir`, `git init`, `mv` and similar in a code block for the user to run. Read-only scans are fine. File writes use the file tool |
| Sources first, nothing dropped | Every pointer gets a row in `SOURCES.md`, reachable or not. Always save a local copy to `sources/` when the content is readable |
| Every claim tagged | Each digest claim in `PLAN.md` cites its `SOURCES.md` row, e.g. `[S2]` |
| No completion without evidence | A phase is ✅ only with a passing test, verified behavior, or a confirmed deploy |
| Generic | No company, team, repo, account, or tool names unless the user gave them |

## Steps

**1. Resolve the target (read-only).**
- Check whether the folder exists, whether it is a git repo, and which template files already exist in it.
- Check the folder and every parent for `CLAUDE.md`, `.claude/CLAUDE.md`, or `CLAUDE.local.md`. If any exists, warn: Claude Code will read that instead of the new `AGENTS.md`. `~/.claude/CLAUDE.md` does not count.
- Draft whatever is missing for the user, in one block:

```sh
mkdir -p <path>
git -C <path> init
```

**2. Kickoff interview (sources first).** One question per message, in this order. Skip any the user already answered.

| # | Ask for | Feeds |
|---|---------|-------|
| 1 | Pointers and context: doc links, wiki pages, PDF paths, chat threads, tickets, raw notes | `SOURCES.md`, ingestion |
| 2 | Project name and folder path | Title, target |
| 3 | A one-line goal. Propose one from the sources read so far; let the user correct it | `AGENTS.md`, `PLAN.md` |
| 4 | Relevant repos or systems, and the local workspace root if any. Don't assume | `references/workspace-repos.md` |
| 5 | Legal, compliance, security, or cross-team gates to flag up front | `AGENTS.md` work item |
| 6 | Environment safety: which environments are production, what the agent may never touch, data-handling limits (e.g. no PII) | `AGENTS.md` safety |
| 7 | Working preferences, coding standards, or workflow skills to invoke (style guides, commit or PR conventions) | `AGENTS.md` how we work |

After answer 1, read every reachable source (local files, and any doc, wiki, chat, or ticket connector available) so question 3 can propose a goal.
Don't ask whether to save copies or whether to use git; the rules already decide.

**3. Scan the workspace (read-only, only if a root was given).** For each relevant repo, take a one-line purpose from its README or manifest.

**4. Build the base.** Only after the interview, and only once the target folder exists (wait for the user to run the drafted `mkdir`).
- Write each missing file from `templates/`, replacing `<PLACEHOLDER>` tokens with interview answers. Leave a token in place when there is no answer yet.
- Save a durable copy of each readable source into `sources/` (e.g. `sources/S2-incident-notes.txt`) by reading it and writing the content with the file tool, which also creates `sources/`. If nothing was saved, write `sources/.gitkeep`.
- `SOURCES.md`: one row per pointer. Ingested: `✅ 🗄️` plus what we learned. Unreachable (auth required, no connector, no access): `📥 recorded, not yet ingested`, with the reason in "What it is".
- `PLAN.md`: write the initial context digest, tagging every claim with its row, e.g. `- Retries tripled traffic after a timeout change [S1]`.
- If `SOURCES.md` or `PLAN.md` already exists, don't rewrite it. Show the rows or sections you would append, and append them only after the user approves.

**5. Report and hand off.** Show a table of each path with `created`, `skipped (exists)`, or `proposed append`, then the drafted shell commands still to run. Start workflow step 1.

## The workflow it drives

1. Deep interview to reach a shared understanding, captured in `PLAN.md`.
2. Break the expectation into testable phases.
3. Implement one phase at a time, verifying each before moving on.
4. Close the loop by confirming the whole thing is testable end to end.

Work interactively and don't guess past ambiguity.

## Common mistakes

| Mistake | Instead |
|---------|---------|
| Inventing a layout (`README.md`, `notes/`, `findings.md`, a running log) | Exactly the files in the table above |
| A dozen questions in one message, or domain guesses (vendors, backends) | One question at a time, in the interview order |
| Listing unreachable links only in prose | A `📥` row in `SOURCES.md` for each |
| Summarizing a source without keeping a copy | Save it to `sources/` and mark `🗄️` |
| Running `mkdir`, `git init`, or `cp` | Draft them for the user; save copies by writing files with the file tool |
| Creating `CLAUDE.md` or a symlink to `AGENTS.md` | `AGENTS.md` only |
| Editing an existing `PLAN.md` directly | Propose the append, then wait for approval |
