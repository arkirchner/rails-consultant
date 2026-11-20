# Rails Consultant

[![skills.sh](https://skills.sh/b/thoughtbot/rails-consultant)](https://skills.sh/thoughtbot/rails-consultant)

This is a simple set of skills optimized for general-purpose software
development across tech stacks.

Our preference is to rely on the [built-in commands][1] as much as possible,
which is why we have such a small set of skills.

## Source Material

Several skills draw on articles, books, and talks created by thoughtbot:

- [Testing from the Outside-In][outside-in]
- [Rails Test Types and the Testing Pyramid][testing-pyramid]
- [Break Apart Your Features into Full-Stack Slices][full-stack-slices]
- [Job Stories][job-stories]

## Installation

### Claude Code

Add thoughtbot's marketplace:

```
/plugin marketplace add thoughtbot/skills
```

Install the plugin:

```
/plugin install rails-consultant@skills
```

### OpenCode and Codex

```
npx skills@latest add thoughtbot/rails-consultant
```

Choose OpenCode or Codex when prompted. In OpenCode, ask it to load the skill
by name, such as “Use the `slice` skill for invoice export,” or use `@slice` in
OpenCode V2. In Codex, use `$slice` followed by the request. The examples below
use Claude Code's `/slice` syntax. See [OpenCode skills][opencode-skills] and
[Codex skills][codex-skills] for discovery and invocation.

## How to use these skills

These skills can be run independently, but are intended to be run in a series
of **new sessions** when building out a feature from start to finish.

### Discovery and planning

> [!TIP]
> If you use Claude Code and want help choosing a feature or writing a prompt,
> start with [`/ask-claude`][38]. In OpenCode or Codex, ask which feature fits
> the job and request a prompt you can review before it runs. Point the agent
> to the [OpenCode docs][opencode-skills] or [official OpenAI docs][codex-skills].

0. Optionally, use [`/domain-model`][26] on new projects or features to capture
   business logic.
   - Use [`/understand`][25] and/or [`/eli5`][28] to reinforce your
     understanding of the business logic.
   - Use [`/trace`][36] to see what an existing flow actually does before you
     change it.
1. First, use [`/slice`][2] to come up with the simplest possible thing to ship
   that adds value.
   - Use [`/understand`][25] and/or [`/eli5`][28] to reinforce your
     understanding of the generated SPEC.
   - Use [`/rubber-duck`][24] to slow down and scrutinize the generated SPEC.

### Implementation

2. Then, run [`/preparatory-refactor`][3] to see if there's an opportunity to
   refactor ahead of time to make the feature easier to implement.
3. Then, run [`/implement-with-tdd`][4] against the SPEC created from
   [`/slice`][2] to drive out the simplest implementation.
4. Then, run [`/multi-lens-review`][5] to find defects in that implementation,
   and to refactor it.

### Verification and review

5. Verify the change against the running app. Use Claude Code's [verification
   skill][30], or ask OpenCode or Codex to start the app with the project's
   documented setup and exercise each acceptance criterion through its normal
   entry point. Ask it to report what it exercised and what remains unverified.
6. Then, run [`/diff-explainer`][6] to create an HTML walkthrough. Claude Code
   can publish it as an [Artifact][7]. OpenCode and Codex can save it locally
   for you to open in a browser.
   - After reviewing the artifact, use [`/rubber-duck`][24] to slow down and
     scrutinize generated code, or [`/understand`][25] to reinforce your
     understanding. If you need more help, start with [`/eli5`][28].
7. Finally, run [`/pr`][34] to open a PR with a description you write
   yourself. The feature is your responsibility, and writing about it helps it
   stick.

### Running them as a workflow

[`/ship`][31] runs steps 2 through 5 and opens a draft PR with `/pr --auto`.
Use `/ship docs/specs/the-slug.md` in Claude Code to run the [dynamic
workflow][21], or start the same phases with subagents in OpenCode or Codex:

```text
OpenCode  Use the ship skill with docs/specs/the-slug.md.
Codex     $ship docs/specs/the-slug.md
```

Each step gets its own context, and each one commits with [`/commit`][32] before
the next starts.

The draft PR stands in for step 6. Its description and line notes cover the
why and the risks. Anything still owed comes back to you in the terminal,
not as a PR comment. You rewrite the description before marking it ready.
Screenshots from verification stay on the machine that ran it; nothing
uploads them yet.

## Evals

Every skill has [eval cases][40] in `evals/<skill>/`. The ones for
[`/ask-claude`][39] sit directly in `evals/`. Run one skill's cases using
the Claude Code eval runner from the repo root:

```
claude plugin eval . --case 'slice-*' --scaffold --max-cost-usd 10 --allow-tools Write Bash
```

- Case names start with the skill's name, which is what `--case` matches.
- `--scaffold` runs the fixture declared in the case's `case.yaml`, which
  builds the sample app it runs against.
- Most skills need `--allow-tools Write Bash`. `/ship` also needs `Edit
Workflow`. `/ask-claude` needs `"WebFetch(domain:code.claude.com)"
"WebFetch(domain:platform.claude.com)"` instead.
- Each skill's baseline scores are in its "Add evals for" PR, listed in
  [discussion #71][42].
- Every run is billed to your account, from about $0.10 for a question that
  shouldn't trigger a skill to about $2.40 for a `/ship` run.
- The CLI needs its own login, even inside the desktop app: `claude auth login`.
- Results go to `evals/results/`, which is gitignored.
- The `/pr` cases also need `--allow-tools Bash Write Edit Agent`.

To check a portable skill in OpenCode or Codex, open a disposable workspace. If
the case declares `context.scaffold_script` in `case.yaml`, run that script from
the workspace, using its path relative to the case directory. Send the body of
`prompt.md` in a fresh session with the skill installed and follow any
interactive turns.

Use `graders/` as the checklist. Check replies and files against the same
expected outcomes. For trace checks, look for the equivalent host events or
artifacts. For example:

- Check skill selection and delegation in the host's session record. For
  multi-lens review, check the lens results and any disclosed sequential
  fallback. For the empty-diff case, check that no reviewer started.
- For Ship attribution, inspect the final draft PR body and inline notes, or
  the retained draft if the PR could not open. Check the model or host credit
  on the body and each note.

Mark a check unverified when the host exposes no equivalent evidence. The
Claude Code runner still uses its own YAML tool and trace settings.

## Reference

### Ask Claude

[`/ask-claude`][39] references the Claude docs to figure out the best tool for
the job, whether that's a hook, a skill, or just a better prompt. It shows you
the prompt before running anything.

### Commit

[`/commit`][33] turns your changes into atomic commits. Each message captures
the why, risks, tradeoffs and alternatives considered, so the history serves as
an audit log of what the LLM did.

Used by `/ship` for every commit, which gives `/diff-explainer` the context it
needs.

### Diff explainer

[`/diff-explainer`][8] is meant to help someone understand the why, risks,
tradeoffs and alternatives considered when viewing a `diff` generated by an LLM
through an [artifact][7].

Because agentic coding sometimes means you're not actually authoring your code,
you lose context into the decision-making process of each commit.

The reviewer may not know the problem either, so the page opens with a simple
everyday analogy for it unless you ask it not to.

If you're working in an unfamiliar tech-stack, name the one you know and it'll
explain the change in those terms:

```
/diff-explainer from the perspective of a WordPress developer
```

Otherwise it uses the background in your project instructions (`AGENTS.md`
or `CLAUDE.md`) when available. With no background, it explains the change in
the stack's own terms.

Finally, in order to be consistent across artifacts, the template ships its own
small stylesheet, so every walkthrough looks the same.

### Domain model

[`/domain-model`][27] takes a business process described in plain language and
extracts the domain. Useful for new projects and features, but can be run at
any time.

### ELI5

[`/eli5`][29] explains code or a concept as simply as possible. Opens with a
simple everyday analogy unless you ask it not to, then uses real values from
the codebase when possible to help create simple, concrete demonstrations.

Use [`/understand`][23] to help you reinforce what you've learned.

### Implement with TDD

[`/implement-with-tdd`][10] drives out an implementation with TDD, working
[from the outside in][11] and starting with [shameless green][12]. This skill
is optimized to cap a feature at around 200 lines of code in an effort to keep
things small.

Intended to be run after `/preparatory-refactor`, but before
`/multi-lens-review`.

### Multi-lens review

[`/multi-lens-review`][15] reviews a change through five lenses: one
hunting defects (bugs, performance, security), one checking we adhered to the
SPEC, one on code quality and reducing [smells][16], one identifying emerging
domains, and one asking what still depends on the behavior we replaced. It
uses parallel subagents where available and runs the lenses in sequence otherwise.

In Claude Code, the defects lens covers the ground of the built-in
[`/code-review` and `/security-review` commands][1].
In Codex, use [native `/review`][codex-review] for an optional second pass.

### Preparatory refactor

[`/preparatory-refactor`][13] takes a SPEC or plan and identifies opportunities
for a [preparatory refactor][14].

Intended to be run after `/slice`, but before `/implement-with-tdd`.

Note that `/multi-lens-review` contains an Agent responsible for identifying
emerging Domains.

### PR

[`/pr`][35] opens a PR, but leaves the description to you. It briefs you on
what changed, suggests a title in the repo's style, and then waits for you to
write the description. Once you do, it proofreads it lightly and opens the PR
after you sign off on the exact text.

`/pr --auto` is for when nobody's around. It opens a draft PR whose body says,
in plain English, what changed for the people using the product and why. No
file paths or commit SHAs. Risks, tradeoffs, and open questions go up as inline
comments on the lines they're about, each with a plain-English version in the
style of `/eli5`: an everyday analogy, and an ASCII drawing when the order of
events is the point. You rewrite the description before
marking it ready. Off GitHub, it replies with the title, body, and notes
instead.

It doesn't take or host screenshots. Pass image URLs you've already uploaded
with `--screenshots`, and it embeds them in the body:

```
/pr --auto --screenshots https://example.com/orders-before.png https://example.com/orders-after.png
```

### Risk score

[`/risk-score`][43] scores how risky a PR or branch is and replies with JSON,
so CI can act on it. A script does the scoring with fixed rules, so the same
diff always gets the same score. The agent picks the diff and hands back what
the script printed, even when you tell it the change is tiny.

```
/risk-score            # this branch vs. its base
/risk-score 123        # PR 123, via gh
/risk-score release    # this branch vs. release
```

The rules and their points are listed in the skill. They recognize the
migrations, config, and dependency files of most stacks, not just Rails: a Knex
`dropColumn` scores the same as a Rails `remove_column`. To change how
something scores, change `skills/risk-score/scripts/score.py` in a PR of its own.

In CI, run the script directly and gate on the level:

```
gh pr diff 123 | python3 skills/risk-score/scripts/score.py | jq -e '.level != "high"'
```

### Rubber duck

[`/rubber-duck`][22] is what the name implies. Use this when you want to slow
down and scrutinize generated code or a SPEC generated by `/slice`.

### Ship

[`/ship`][31] runs steps 2 through 5 against a SPEC and opens a draft PR. It uses
Claude Code's [Workflow tool][21] or the host's subagents.

### Slice

[`/slice`][17] turns a rough idea into a [vertical slice][18] with accompanying
[job stories][19] and acceptance criteria.

The idea is that the smaller the slice, the easier it'll be for an LLM or human
to implement and ship.

The SPEC also carries a short list of the files recon read, stamped with the
commit it read them at. `/preparatory-refactor` and `/implement-with-tdd` start
from those paths instead of rediscovering them. They're pointers, not a plan —
neither skill treats the list as scope, and the repo wins where they disagree.

Pass `--auto` to run it without a human, like from a GitHub issue:

```
/slice --auto <the idea or issue body>
```

It skips the interview and makes the cuts itself. A fresh subagent reviews the
draft when delegation is available, and anything the draft had to assume goes under
`## Assumptions`. It replies with the SPEC instead of writing a file, so the
reply can be posted as a comment on the issue.

### Trace

[`/trace`][37] runs a scenario, like "user creates an account", in your
development environment and records what actually happened, in order. Anything destructive, like killing a process or dropping a database, is
stubbed. The trace is saved to `docs/traces/`.

Useful during discovery and planning, and pairs well with `/eli5` and `/slice`.

### Understand

[`/understand`][23] helps you understand something by using the [Socratic
method][20] instead of explaining it to you.

Pairs well with `/diff-explainer`, `/domain-model`, and `/slice` since it'll
help reinforce your understanding.

Use [`/eli5`][29] if you have no familiarity with the subject matter.

## Contributing

See the [CONTRIBUTING][] document.
Thank you, [contributors][]!

## License

Rails Consultant is Copyright (c) thoughtbot, inc.
It is free software, and may be redistributed
under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

## About thoughtbot

![thoughtbot](https://thoughtbot.com/thoughtbot-logo-for-readmes.svg)

This repo is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community].
We are [available for hire][hire].

[CONTRIBUTING]: CONTRIBUTING.md
[community]: https://thoughtbot.com/community?utm_source=github
[contributors]: https://github.com/thoughtbot/rails-consultant/graphs/contributors
[hire]: https://thoughtbot.com/hire-us?utm_source=github
[full-stack-slices]: https://thoughtbot.com/blog/break-apart-your-features-into-full-stack-slices
[job-stories]: https://thoughtbot.com/playbook/rapid-product-validation/jtbd#how-to-write-and-use-job-stories
[outside-in]: https://thoughtbot.com/blog/testing-from-the-outsidein
[testing-pyramid]: https://thoughtbot.com/blog/rails-test-types-and-the-testing-pyramid
[1]: https://code.claude.com/docs/en/commands
[2]: #slice
[3]: #preparatory-refactor
[4]: #implement-with-tdd
[5]: #multi-lens-review
[6]: #diff-explainer
[7]: https://code.claude.com/docs/en/artifacts
[8]: skills/diff-explainer/SKILL.md
[10]: skills/implement-with-tdd/SKILL.md
[11]: https://thoughtbot.com/blog/testing-from-the-outsidein
[12]: https://sandimetz.com/99bottles-sample-ruby
[13]: skills/preparatory-refactor/SKILL.md
[14]: https://martinfowler.com/articles/preparatory-refactoring-example.html
[15]: skills/multi-lens-review/SKILL.md
[16]: https://refactoring.guru/refactoring/smells
[17]: skills/slice/SKILL.md
[18]: https://thoughtbot.com/blog/break-apart-your-features-into-full-stack-slices
[19]: https://thoughtbot.com/blog/product-management-templates-job-story
[20]: https://en.wikipedia.org/wiki/Socratic_method
[21]: https://code.claude.com/docs/en/workflows
[22]: skills/rubber-duck/SKILL.md
[23]: skills/understand/SKILL.md
[24]: #rubber-duck
[25]: #understand
[26]: #domain-model
[27]: skills/domain-model/SKILL.md
[28]: #eli5
[29]: skills/eli5/SKILL.md
[30]: https://code.claude.com/docs/en/skills#run-and-verify-your-app
[31]: skills/ship/SKILL.md
[32]: #commit
[33]: skills/commit/SKILL.md
[34]: #pr
[35]: skills/pr/SKILL.md
[36]: #trace
[37]: skills/trace/SKILL.md
[38]: #ask-claude
[39]: skills/ask-claude/SKILL.md
[40]: https://code.claude.com/docs/en/plugin-evals
[42]: https://github.com/stevepolitodesign/skills/discussions/71
[43]: skills/risk-score/SKILL.md
[codex-skills]: https://developers.openai.com/codex/skills
[codex-review]: https://learn.chatgpt.com/docs/developer-commands?surface=cli#ask-for-a-working-tree-review-with-review
[opencode-skills]: https://opencode.ai/docs/skills/
