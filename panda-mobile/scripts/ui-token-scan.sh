#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Some environments set LC_ALL=C.UTF-8 but do not have that locale installed.
if [[ "${LC_ALL:-}" == "C.UTF-8" ]]; then
  export LC_ALL=C
fi

TARGET_GLOBS=(
  "*.uvue"
  "*.vue"
  "*.scss"
  "*.css"
  "*.ts"
  "*.js"
  "*.uts"
)

EXCLUDE_GLOBS=(
  "!docs/**"
  "!tokens/**"
  "!scripts/**"
  "!unpackage/**"
  "!node_modules/**"
  "!dist/**"
  "!build/**"
  "!uni.scss"
)

DISABLE_MARKER_REGEX='ui-lint-disable(-next-line|-line)?'

build_rg_cmd() {
  local cmd=("rg" "-n" "--no-heading" "--color" "never" "--hidden")
  local g
  for g in "${TARGET_GLOBS[@]}"; do
    cmd+=("-g" "$g")
  done
  for g in "${EXCLUDE_GLOBS[@]}"; do
    cmd+=("-g" "$g")
  done
  printf "%s\n" "${cmd[@]}"
}

run_scan_rg() {
  local pattern="$1"
  local -a cmd
  mapfile -t cmd < <(build_rg_cmd)
  "${cmd[@]}" -e "$pattern" . || true
}

run_scan_grep() {
  local pattern="$1"
  grep -RInE "$pattern" \
    --include="*.uvue" \
    --include="*.vue" \
    --include="*.scss" \
    --include="*.css" \
    --include="*.ts" \
    --include="*.js" \
    --include="*.uts" \
    --exclude-dir=docs \
    --exclude-dir=tokens \
    --exclude-dir=scripts \
    --exclude-dir=unpackage \
    --exclude-dir=node_modules \
    --exclude-dir=dist \
    --exclude-dir=build \
    . || true
}

scan() {
  local pattern="$1"
  if command -v rg >/dev/null 2>&1; then
    run_scan_rg "$pattern"
  else
    run_scan_grep "$pattern"
  fi
}

run_check() {
  local title="$1"
  local pattern="$2"
  local result
  result="$(scan "$pattern" | grep -Ev "$DISABLE_MARKER_REGEX" || true)"
  if [[ -n "$result" ]]; then
    HAS_FAILURE=1
    echo
    echo "[FAIL] ${title}"
    echo "$result"
  fi
}

HAS_FAILURE=0

echo "Running Panda UI token scan..."

# 1) Raw color values: #hex, rgb(), rgba(), hsl(), hsla()
run_check "Raw color values detected" '#([0-9a-fA-F]{3,8})\b|rgba?\(|hsla?\('

# 2) Raw px values on common visual properties
run_check "Raw size values detected" '(font-size|padding|padding-(top|right|bottom|left)|margin|margin-(top|right|bottom|left)|border-radius|gap|row-gap|column-gap)\s*:\s*[0-9]+(\.[0-9]+)?px\b'

# 3) Inline style hardcoded in templates
run_check "Inline style hardcoding detected" 'style\s*=\s*"[^"]*(#([0-9a-fA-F]{3,8})|rgba?\(|hsla?\(|[0-9]+(\.[0-9]+)?px)'

# 4) font-family hardcoded outside token layer
run_check "Raw font-family detected" 'font-family\s*:'

if [[ "$HAS_FAILURE" -eq 1 ]]; then
  echo
  echo "UI token scan failed."
  echo "Fix violations by using tokens from tokens/panda.tokens.json."
  echo "If an exception is required, annotate with ui-lint-disable and a reason."
  exit 1
fi

echo "UI token scan passed."
