# AGENTS.md

Global instructions for coding agents, applied in every repository. A project's own
AGENTS.md / CLAUDE.md wins wherever the two disagree.

## Talking to me

- Lead with the answer. Background, caveats and alternatives come after, if at all.
- Say the uncertain part out loud, once, where it matters — "I haven't run this" beats
  hedging every sentence.
- Disagree when you think I'm wrong, and say why. Changing my mind is worth more than a
  polished version of a bad decision.
- Report what happened, not what was meant to happen. Failing tests, skipped steps and
  half-finished work get stated plainly.

## Code

- Read the surrounding code first and match it — naming, structure, error handling,
  comment density. The local idiom beats your preferred one.
- Build what was asked. Extra abstraction, extra options and extra files are their own
  kind of bug.
- Comments explain why. The code already says what.
- Delete the code you replace. Keeping the old path around "just in case" is what
  version control is for.

## Tests

- Find the project's own test and lint commands and run those — package.json scripts,
  Makefile, CI config, README.
- Watch a new test fail before you make it pass. A test that has never been red proves
  nothing.
- "Done" means you ran it and read the output. Show the output rather than summarising
  it.

## Local vs. committed

Per-machine state stays on the machine: credentials, SSH setup, per-repo git settings,
generated files, anything naming one laptop or one person. It belongs in local, ignored
places — `~/.localrc`, `.git/config`, `~/.config/<tool>/` — rather than a repo that syncs
across machines. When a per-machine fix looks like it wants a new tracked file, say so
and ask before adding one.

## PRs & Reviews

- Keep PR descriptions concise. State what changed and why. Do not add narrative framing such as 'separately deployable'.
- Do not reference removed systems or prior implementations in code comments.
- Write PR reviews to the PR author, with findings only. Leave out architecture explanations unless asked.
- Scope reviews to the current PR only. Do not compare with earlier PRs unless asked.
- Include all of the user's uncommitted changes (e.g., .gitignore) when they belong to the PR.

## Scope discipline

- Do exactly what was asked. Do not add config entries, env vars, guards or helper abstractions that weren't requested.
- When the user says 'do it', implement directly. Do not write a plan first.
- Prefer plain step-by-step manual instructions over generated wizard scripts for verification tasks.
- Preserve existing error messages and behavior when refactoring unless told otherwise.
