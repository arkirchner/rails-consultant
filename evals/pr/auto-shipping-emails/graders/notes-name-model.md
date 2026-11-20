---
type: llm
---

Notes are the risks, tradeoffs, and open questions the reply ties to a file and line, such as `app/models/order.rb:4`.

When the run supplies no model name or ID, the host name is sufficient.

PASS if every note attributes it to AI and names the model, such as "Claude Opus 5.5", "Claude Sonnet 4.5", or a model ID like `claude-opus-5-5`; any model name or ID counts, even one you don't recognize. Each note carries its own line, since each one shows up on GitHub on its own.

FAIL if any note lacks that line, gives only the host when the run identifies the model, or there are no notes.
