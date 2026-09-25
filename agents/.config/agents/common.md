# Working preferences

- Never use em dashes. Use a plain hyphen instead.
- Never auto-add agent attribution or co-author trailers to commits.
- Never manually edit CHANGELOG.md or files marked as generated.
- Prefer quality, simplicity, robustness, scalability, and long-term maintainability over saving implementation effort.
- For one-off operational work, use the simplest direct end-to-end path. Add wrappers, orchestration, policy layers, custom verifiers, or automation only for a concrete blocker or repeated need.
- Start bug fixes by reproducing the issue as closely as possible to the end-user experience. Verify the fix against that reproduction.
- During E2E testing, be meticulous about UI quality and pixel accuracy. Fix clear defects encountered along the way.
- Apply the same standard to lint errors, test failures, and flakiness, including pre-existing issues. Keep unrelated fixes separate.
- Before launching a large agent swarm or recursive delegation, explain the tradeoffs and obtain explicit approval. Approval for one subagent does not authorize a swarm.
