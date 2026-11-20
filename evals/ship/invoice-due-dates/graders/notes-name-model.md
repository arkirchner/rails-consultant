---
type: llm
focus: trace
---

The run ends with notes for the PR: risks, tradeoffs, and open questions tied to a file and line. Use the last set: the `notes` the `open:check` agent returned if it returned any, else the `notes` the `open:pr` agent sent. That includes any note the check agent added or rewrote.

When the run supplies no model name or ID, the host name is sufficient.

PASS if every note in that set ends with a line naming the model, such as "Claude Opus 5.5" or a model ID like `claude-opus-5-5`. Any model name or ID counts, even one you don't recognize.

FAIL if any note lacks that line, gives only the host when the run identifies the model, or there are no notes.
