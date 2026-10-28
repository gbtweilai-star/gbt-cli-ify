#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_cli_ify info
PYTHONPATH=src python -m gbt_cli_ify check --payload '{}'
PYTHONPATH=src python -m gbt_cli_ify run   --payload '{}'
