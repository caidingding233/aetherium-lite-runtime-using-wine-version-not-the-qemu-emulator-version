#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCRIPT_DIR="${ROOT_DIR}/scripts/proton-runtime"

"${SCRIPT_DIR}/fetch_sources.sh"
"${SCRIPT_DIR}/apply_corresponding_source_patches.sh"
"${SCRIPT_DIR}/ensure_runtime_sources.sh" all
"${SCRIPT_DIR}/audit_licenses.sh"

printf '[proton-runtime] bootstrap complete. Next: configure/build the runtime, then assemble Proton.hsp and entry HAP.\n'
