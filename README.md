# cli_ify

**One capability bit from GBT V8, packaged standalone.** No. 102 of 341,
`integration` domain (Integration).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> **软件命令化**（主人令 2026-10-16 深度蒸馏自 HKUDS/CLI-Anything）：上游原文现读（200·80,551 字）后补齐三块——**Agent-Software Gap**（智能体推理强、用真业务软件很差；焦位版重写会丢 90% 功能 ⇒ **包壳不重写**）· **7 相流水线**（Analyze→Design→Implement→Plan Tests→Write Tests→Docs→Publish）· **CLI-Hub 注册表**（对应本仓 state/cli-surfaces.json）。op=status/gate/plan/registry/check/gap（**全只读·零作用域**）。

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-cli-ify.git
cd gbt-cli-ify
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_cli_ify info                  # capability card
python -m gbt_cli_ify spec --json           # machine-readable contract
python -m gbt_cli_ify check --payload '{}'
python -m gbt_cli_ify run   --payload '{}'
```

Real `info` output from this machine:

```text
cli_ify  (integration)  v1.0.0
----------------------------------------
**软件命令化**（主人令 2026-10-16 深度蒸馏自 HKUDS/CLI-Anything）：上游原文现读（200·80,551 字）后补齐三块——**Agent-Software Gap**（智能体推理强、用真业务软件很差；焦位版重写会丢 90% 功能 ⇒ **包壳不重写**）· **7 相流水线**（Analyze→Design→Implement→Plan Tests→Write Tests→Docs→Publish）· **CLI-Hub 注册表**（对应本仓 state/cli-surfaces.json）。op=status/gate/plan/registry/check/gap（**全只读·零作用域**）。

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : status, gate, plan, registry, check, gap
```

Wire a real implementation:

```python
from gbt_cli_ify import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（6 个）**：`status`、`gate`、`plan`、`registry`、`check`、`gap`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.12s
```

## Provenance

| field | value |
|---|---|
| capability | `cli_ify` |
| domain | `integration` |
| handler | `cli_ify` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [integration/cli_ify](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/integration/cli_ify.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
