#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC_DIR="${ROOT_DIR}/third_party/proton-runtime/src"
PATCH_DIR="${ROOT_DIR}/third_party/proton-runtime/source-patches"

apply_component_patch() {
  local component="$1"
  local patch="$2"
  local repo_dir="${SRC_DIR}/${component}"
  local patch_path="${PATCH_DIR}/${component}/${patch}"

  if [[ ! -d "${repo_dir}/.git" ]]; then
    printf '[runtime] missing source checkout: %s\n' "${repo_dir}" >&2
    exit 1
  fi
  if [[ ! -f "${patch_path}" ]]; then
    printf '[runtime] missing patch: %s\n' "${patch_path}" >&2
    exit 1
  fi

  if git -C "${repo_dir}" apply --reverse --check "${patch_path}" >/dev/null 2>&1; then
    printf '[runtime] patch already applied: %s/%s\n' "${component}" "${patch}"
    return
  fi

  git -C "${repo_dir}" apply "${patch_path}"
  printf '[runtime] patch applied: %s/%s\n' "${component}" "${patch}"
}

apply_component_patch box64 0001-hmos-local-working-tree.patch
apply_component_patch wine 0001-hmos-local-working-tree.patch
