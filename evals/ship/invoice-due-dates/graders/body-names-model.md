---
type: llm
focus: trace
---

The run ends with a PR description. Use the last version of it: the `body` the `open:check` agent returned if it returned one, else the `body` the `open:pr` agent sent. Notes tied to a file and line are not the body.

When the run supplies no model name or ID, the host name is sufficient.

PASS if that body's last paragraph attributes it to AI and names the model, such as "Claude Opus 5.5", "Claude Sonnet 4.5", or a model ID like `claude-opus-5-5`. Any model name or ID counts, even one you don't recognize. The paragraph may wrap onto two lines.

FAIL if it has no such paragraph, gives only the host when the run identifies the model, or other body content comes after it.
