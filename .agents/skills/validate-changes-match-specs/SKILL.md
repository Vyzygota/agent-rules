---
name: validate-changes-match-specs
description: Validate that a branch or pull request implementation matches introduced product, technical, security, and related specs. Use when reviewing or finishing a spec-driven change and resolving mismatches between checked-in specs and implementation. More thorough and interactive than check-impl-against-spec — use for comprehensive validation with resolution workflow.
---

# Validate changes match specs

Use this skill to verify that a branch or pull request implements the behavior and design promised by its specs. The workflow finds specs introduced by the change, compares them against code, tests, documentation, and validation artifacts, then walks the user through every material mismatch.

## Goals

- Find specs introduced or modified by the current change.
- Extract concrete product, technical, security, migration, rollout, and validation commitments.
- Compare those commitments against the actual implementation.
- Produce a clear mismatch list.
- Ask the user, mismatch by mismatch, whether to update the implementation to match the spec or update the spec to match the implementation.
- Apply the chosen resolutions either one-by-one or in a batch.

## Spec discovery

Start by identifying the base branch and changed files.

Prefer repository conventions when known. Otherwise:

- Use the PR base branch when a PR exists.
- Use `main`, `master`, or `develop` only when that is clearly the repository's base branch.
- Use `git merge-base` and `git diff --name-only <base>...HEAD` to find files introduced or modified by the branch.

Look for specs introduced or modified by the change, especially under `specs/`.

Common spec names include:

- `PRODUCT.md`
- `product.md`
- `TECH.md`
- `tech.md`
- `SECURITY.md`
- `security.md`

Treat any markdown file bundled under a relevant `specs/<issue-number>/` directory as a valid spec candidate. Examples include focused specs such as `MIGRATION.md`, `ROLLBACK.md`, `PRIVACY.md`, `API.md`, or `TESTING.md`.

If no specs were introduced or modified, look for existing specs referenced by the PR description, commit messages, branch name, changed files, or nearby `specs/` directories. If there is still no relevant spec, stop and report that there is no spec to validate against.

## Context gathering

Read every relevant spec before assessing implementation. Extract explicit commitments into categories:

- **Product behavior:** user-visible behavior, UX flows, success criteria, constraints, and edge cases.
- **Technical implementation:** files, components, APIs, data models, migrations, feature flags, architecture, dependencies, and rollout mechanics.
- **Security and privacy:** authentication, authorization, permission boundaries, secrets, data handling, logging, retention, abuse cases, and compliance claims.
- **Validation:** required tests, manual checks, fixtures, CI commands, migration checks, and acceptance criteria.
- **Non-goals:** scope exclusions and intentionally deferred work.

Then inspect the implementation:

- Changed code and docs from the branch diff.
- Relevant unchanged files that the implementation depends on.
- Tests that were added, removed, or should have been updated.
- PR description and commit messages when available.
- Existing validation output, if the user has attached it.
- PR review comments and replies, if the change has already been through external review.

Do not rely only on file names or summaries. Read enough code and tests to decide whether each spec commitment is actually implemented.

## PR review comment consistency

If the branch or PR has already been through external PR review, check the review comments before finalizing the mismatch report.

For each review thread with a response from the current user or agent:

- Identify the original reviewer request.
- Identify the latest acknowledged resolution from the current user or agent, especially replies that say the comment was fixed in a particular way.
- Compare the final implementation against that acknowledged resolution.
- Skip threads where the latest reviewer follow-up supersedes the prior acknowledgment, unless there is a newer reply that responds to it.

Treat a material difference between the implementation and the last acknowledged resolution as a `review-comment consistency` mismatch. Include the review comment URL, the acknowledged resolution text, the relevant implementation path and line when available, and why the implementation does or does not match what was promised.

## Security spec validation

When a security, privacy, compliance, permissions, auth, data-handling, or logging spec is present, validate it especially thoroughly. Treat the security spec as a set of explicit guarantees and threat mitigations.

For each security commitment, verify both:

- the positive path: the intended behavior is implemented
- the negative path: prohibited or unsafe behavior is prevented

Check implementation details such as:

- authentication and authorization boundaries
- permission checks and role distinctions
- input validation, output encoding, and injection risks
- sensitive data exposure in UI, logs, errors, URLs, caches, and files
- secret handling and credential propagation
- rate limits, abuse cases, replay behavior

If you discover a plausible security gap not covered by the security spec, include it as a proposed spec amendment. Mark it as `security amendment` in the mismatch report, explain the risk, and ask the user whether to update the spec, update the implementation, both, or acknowledge without changes.

## Validation criteria

Treat a mismatch as material when any of these are true:

- The implementation omits behavior required by the product spec.
- The implementation behaves differently from the product spec in a user-visible way.
- The implementation uses a technical approach that contradicts the tech spec in a way that matters for correctness, maintainability, rollout, or review.
- The implementation adds meaningful behavior or scope not described by the specs.
- Security, privacy, permission, or logging behavior differs from the security or product spec.
- A discovered security gap is not covered by an existing security spec.
- The implementation does not match the last acknowledged resolution on a PR review comment.
- Required migrations, rollout steps, feature flags, telemetry, validation, or cleanup are missing.
- Tests or validation promised by the spec are absent or materially weaker than described.
- The spec still describes behavior that was deliberately changed during implementation.

Do not flag harmless implementation details, naming differences, or local refactors when the implementation preserves the spec's intent.

## Mismatch report

Before asking resolution questions, present a concise list of mismatches. For each mismatch include:

- Stable mismatch number.
- Spec source path and section or line when available.
- Implementation source path and line when available.
- Category: product, technical, security, validation, migration, rollout, or scope.
- Review comment URL when the mismatch is based on PR review comment consistency.
- What the spec says.
- What the implementation does.
- Why the difference matters.
- Recommended resolution: update implementation, update spec, or ask for clarification.

If security-relevant mismatches exist, call them out separately.

If no mismatches are found, say that the implementation appears to match the discovered specs, summarize the specs checked, and list any validation that was or was not run.

## Initial resolution mode

When mismatches exist, ask how the user wants to resolve them:

- `Resolve one-by-one`
- `Collect all decisions, then apply in a batch`
- `Other...`

### One-by-one mode

For each mismatch:

1. Show the mismatch number and relevant file references.
2. Ask how to resolve it.
3. Apply the selected resolution immediately.
4. Run the narrowest useful validation for that change when practical.
5. Continue to the next mismatch.

### Batch mode

For each mismatch, collect the user's decision interactively without editing yet. After all decisions are collected, apply all selected changes together, then validate.

## Per-mismatch resolution options

Always offer options with these meanings:

- Update the implementation to match the spec.
- Update the spec to match the implementation.
- Explain this mismatch before deciding.
- Acknowledge without changes.
- `Other...`

## Resolution rules

- Preserve unrelated local changes.
- Do not silently choose between product behavior and implementation behavior when the user has not decided.
- Prefer updating specs when the implementation intentionally diverged and the shipped behavior is correct.
- Prefer updating implementation when the spec describes required user behavior, security behavior, compatibility, migration, or validation guarantees that the code does not satisfy.
- If a mismatch affects security or privacy, be explicit about the risk before asking for a resolution.

## Validation after changes

After applying selected resolutions:

1. Review `git diff` to confirm the changes match the user's decisions.
2. Run relevant validation based on changed files and repository conventions.
3. Re-check the resolved mismatches against the final diff.

## Commit and push

After validation, ask whether the user wants to commit and optionally push the changes.

If the user chooses to commit, stage only the intended files and commit non-interactively.

## Final response

End with a concise summary:

- Specs checked.
- Mismatches found.
- Resolutions applied.
- Files changed.
- Validation run and result.
- Remaining unresolved or intentionally acknowledged mismatches.

## Related Skills

- `check-impl-against-spec` — lightweight read-only alternative for quick checks
- `implement-specs` — for implementing approved specs from scratch
- `spec-driven-implementation` — full spec-driven workflow
