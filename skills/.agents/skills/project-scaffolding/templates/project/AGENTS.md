# <PROJECT>

<ONE-LINE PITCH>

Status: <ONE-LINE STATUS> · Started: <START DATE>

<!-- Keep this file thin: pointers only. It loads into every session, so anything
     inlined here is paid for on every turn. Detail lives in _doctrine/. -->

## Workspace layout

- `_doctrine/`: durable, project-wide truth. Read the relevant file on demand.
- `_work/<YYYYMMDD_slug>/`: one temporal work item per folder, holding its `PLAN.md`. Disposable once its durable results reach `_doctrine/`.
- `code/`: the product. Each service documents itself in its own `code/<service>/AGENTS.md`.

## Self-containment (hard rule)

Everything for this project lives inside this folder: links, PDFs, notes, plans, findings.
Never write to global agent config (e.g. `~/.claude`) or anywhere outside this folder.
Never inflate this file; add context to the files it points to.

## Doctrine index (load on demand)

| File | What's in it | Load when |
|------|--------------|-----------|
| `_doctrine/project.md` | Goal, shared understanding, non-goals, gates | Before planning anything |
| `_doctrine/architecture.md` | Components, boundaries, data flow | Before changing `code/` |
| `_doctrine/decisions.md` | Append-only decision log (the why) | Before revisiting a choice |
| `_doctrine/SOURCES.md` | Every doc, link, PDF, or thread, its ingest status, and what we learned | Before citing or adding a source |
| `_doctrine/sources/` | Durable local copies of source material | When a link is dead or detail is needed |

## How we work

- Start: you'll usually be in a `_work/<item>/` folder. Read its `PLAN.md`, then the relevant `_doctrine/` files, and skim `code/` before planning.
- Finish: append durable choices to `_doctrine/decisions.md` and update the other doctrine files; then the item is done.
- Prefer showing code and commands over prose.
- Be direct, with no preamble or filler.
- Show progress and status as tables.
- Ask one focused question rather than guessing.
- Don't scaffold speculative structure.
- Edit existing files rather than creating new ones.
- Touch only what the task needs.
- Never commit, push, or rewrite history unless asked.
- Standards and skills to invoke: <STANDARDS / SKILLS TO INVOKE>

## Safety & access

- Production: <WHICH ENVIRONMENTS ARE PRODUCTION>
- Never touch: <SYSTEMS OR DATA THE AGENT MAY NEVER TOUCH>
- Data handling: <DATA-HANDLING CONSTRAINTS>
- Draft production commands for the user to run; never execute them.
- Default to non-production.
- In production, read-only investigation only, after confirming the credentials are read-only.
- No secrets reads.
- No sensitive personal data unless explicitly authorized.

## Workflow

1. Deep interview to reach a shared understanding, captured in the work item's `PLAN.md`.
2. Break the expectation into testable phases.
3. Implement one phase at a time, verifying each before moving on.
4. Close the loop by confirming the whole thing is testable end to end.

Work interactively and don't guess past ambiguity.

## Services (grows as we build)

- _(none yet; the first work item defines the code skeleton)_
