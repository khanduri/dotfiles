# <PROJECT> Decision Log

Append-only. One entry per significant choice, newest at the bottom. Capture the
why, not just the what. Format: date, decision, why, and any alternative rejected.

---

### <START DATE>: Adopted the _doctrine / _work / code workspace layout

The root `AGENTS.md` holds pointers only, so it never grows as knowledge does.
Durable knowledge and sources live in `_doctrine/` and are read on demand.
`_work/<YYYYMMDD_slug>/` folders are temporal and disposable. `code/` is the product.
