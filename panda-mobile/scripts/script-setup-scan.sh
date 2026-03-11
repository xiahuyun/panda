#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "Running script setup scan..."

failed=0
script_pattern="<script[[:space:]]+setup([[:space:]]|>)"

match_script_setup() {
  local file="$1"
  if command -v rg >/dev/null 2>&1; then
    rg -q "$script_pattern" "$file"
    return $?
  fi
  grep -Eq "$script_pattern" "$file"
}

while IFS= read -r file; do
  if [[ "$file" == "App.uvue" ]]; then
    continue
  fi

  if ! match_script_setup "$file"; then
    echo "Script setup scan failed: $file does not use <script setup>."
    failed=1
  fi
done < <(find . -type f \( -name "*.vue" -o -name "*.uvue" \) | sed 's#^\./##' | sort)

if [[ "$failed" -ne 0 ]]; then
  echo "Fix violations by converting files to script setup syntax."
  echo "App.uvue is excluded because uni-app x App does not support script setup."
  exit 1
fi

echo "Script setup scan passed."
