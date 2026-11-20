---
type: llm
---

The PR body is the description the reply hands back, usually in a fenced block. Notes tied to a file and line, and anything after the fenced block, are not the body.

When the run supplies no model name or ID, the host name is sufficient.

PASS if the body's last paragraph attributes it to AI and names the model, such as "Claude Opus 5.5", "Claude Sonnet 4.5", or a model ID like `claude-opus-5-5`. Any model name or ID counts, even one you don't recognize. The paragraph may wrap onto two lines.

FAIL if the body has no such paragraph, it gives only the host when the run identifies the model, or other body content (a checklist, a `Closes` line) comes after it.
