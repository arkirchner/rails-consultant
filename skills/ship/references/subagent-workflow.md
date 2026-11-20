# Run Ship with subagents

Coordinate the run from the parent session. Use OpenCode's `general` subagent or
Codex's `worker` for stages that edit, and `explore` or `explorer` for read-only
work when those types are available. An untyped subagent gets the same stage
brief and workspace limits. Use a fresh context for each assignment, with just
the SPEC path, the relevant skill instructions, and the handoff it needs. The
parent resolves skill and reference paths before dispatch. Give reviewers a
no-write brief, including shell commands and Git state. Use the same working
tree throughout. Collect each editing stage's result before starting the next,
and close finished agents when the host counts open threads toward its limit.

If the host cannot start fresh subagents, report that Ship needs separate
contexts and give the user the phase order below to run in fresh sessions.

## Before Prepare

From the repository root, resolve the PR base name with
`gh repo view --json defaultBranchRef -q .defaultBranchRef`. If that gives no
branch name, use the branch named by `refs/remotes/origin/HEAD`, then check for
`origin/main` and `origin/master` in that order. Resolve that branch to a commit,
preferring `refs/remotes/origin/<base>` over `refs/heads/<base>`. Keep both the
branch name and the commit for later stages. Stop before any edits or commits
if HEAD is detached, the current branch is the base branch, or the base commit
or its merge base with `HEAD` can't be resolved. Report the blocker.

Check `git status --porcelain=v1 --untracked-files=all -z`. Compare paths from
the repository root and allow only the exact supplied SPEC path if it is
untracked. Stop for any other entry, including staged or modified SPEC files.
Use the same rule in Open, also allowing this run's own untracked report
artifacts.

## Prepare

Give a read-only agent the `preparatory-refactor` instructions or their absolute
`SKILL.md` path, plus the absolute path to its `references/tells.md`. Have it
apply those instructions directly to the SPEC. If it can't delegate, use the
skill's timeboxed reconnaissance fallback and disclose that in the report. Ask
for the naive diff sketch, confidence in each move, and the test command. If no
move reaches 80, go straight to Implement. Otherwise send the report to a fresh
editing agent to make those behavior-preserving moves. Run the relevant tests
before and after. Stop if the move changes behavior, the suite goes red, or an
agent fails to report its result.

For each editing stage, use `commit` for changes made in that stage. Keep the SPEC,
diff captures, screenshots, logs, and unrelated edits out of those commits. Carry
forward the commit IDs, test commands and results, and unresolved questions.

## Implement

Have a fresh agent run `implement-with-tdd` against the SPEC and commit the work.
Honor the skill's stop conditions and report any unbuilt criteria. Stop for a
decision outside the SPEC or if the implementation agent returns no result.

## Review

In the parent session, follow `multi-lens-review` for target selection, dispatch,
and synthesis. Use the supplied SPEC as the acceptance criteria. Find the merge
base between `HEAD` and the base commit captured before Prepare, and use it to
diff the working tree. Exclude the SPEC and Ship's run artifacts from the captured
diff. Stop if the merge base cannot be resolved or the diff is empty or exceeds
1500 lines. Give all 5 reviewers the same captured diff and the SPEC.
Preserve each lens's tool limits and keep reviewers read-only. Run them in
parallel up to the host's concurrency limit.

After synthesis, give a fresh editing agent the accepted Defects and
Compatibility findings to fix one at a time. Leave Conventions, Domains, and
Fidelity for the user. Stop applying fixes if one turns out larger than the
finding describes. Run the suite, commit any fixes, and record any lens that
couldn't finish or finding that remains open.

## Verify

Have a fresh agent follow the project's documented setup and exercise the built
criteria through the app's normal entry points. Run the suite after any fixes
and commit them. If a screen demonstrates a criterion and the host supports
capture, save a screenshot outside the repo and report its path. Record what
ran, what passed, and what couldn't be exercised.

## Open

Use `pr --auto <base>` with the branch name captured before Prepare. For local
Git comparisons in PR recon and review, use the base commit captured there.
Pass the SPEC and verification results to a fresh writer. Apply the dirty-tree
check from Before Prepare. Tell the writer to stop after drafting and return
the title, body, and notes. Have a fresh read-only agent do the PR skill's
description and line-note check, then pass its findings to the writer for one
revision. Continue with the PR skill's opening and line-note steps to open a
draft PR. If it cannot open, retain the title, body, and notes for the user.

Use the [Ship summary format](../SKILL.md#when-it-returns). If a stage stopped,
name the stage, the reason, and what was committed or verified before the stop.
