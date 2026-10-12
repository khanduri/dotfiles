# <PROJECT> - Working Context

Status: <ONE-LINE STATUS> · Started: <START DATE>

New sessions start here. This file stays lean: it holds pointers, not context.
Context grows in the files below and is loaded on demand.

## Self-containment (hard rule)

Everything for this work item lives inside this folder: links, PDFs, notes, plans, findings.
Never write to global agent config (e.g. `~/.claude`) or anywhere outside this folder.
Never inflate this file; add context to the files it points to.

## Load on demand (pointers)

| File | What's in it | Load when |
|------|--------------|-----------|
| `SOURCES.md` | Every doc, link, PDF, or thread, its ingest status, and what we learned | Before citing or adding a source |
| `PLAN.md` | Shared understanding, testable phases, status, open decisions | Before planning or changing a phase |
| `sources/` | Durable local copies of source material | When a link is dead or detail is needed |
| `references/workspace-repos.md` | Relevant local repos and their purpose | Before touching code in a repo |

## How we work

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

1. Deep interview to reach a shared understanding, captured in `PLAN.md`.
2. Break the expectation into testable phases.
3. Implement one phase at a time, verifying each before moving on.
4. Close the loop by confirming the whole thing is testable end to end.

Work interactively and don't guess past ambiguity.

## The work item

- Goal: <ONE-LINE GOAL>
- Reference: <PRD / ticket / doc link, and any compliance or cross-team gate, or "none">
