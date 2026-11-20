---
type: llm
---

The reply is a GitHub comment. The SPEC sits between a `<!-- spec -->` line and a `<!-- /spec -->` line.

When the run supplies no model name or ID, the host name is sufficient.

PASS if the reply's last paragraph comes after the `<!-- /spec -->` line, attributes it to AI, and names the model, such as "Claude Opus 5.5", "Claude Sonnet 4.5", or a model ID like `claude-opus-5-5`. Any model name or ID counts, even one you don't recognize. The paragraph may wrap onto two lines.

FAIL if there's no such paragraph, it gives only the host when the run identifies the model, it sits inside the SPEC, or other content comes after it.
