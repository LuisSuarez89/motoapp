#!/usr/bin/env bash
set -euo pipefail

ROOT_FILE="app-ads.txt"
WEB_FILE="web/app-ads.txt"
EXPECTED_REGEX='^google\.com, pub-[0-9]{16}, DIRECT, f08c47fec0942fa0$'

for file in "$ROOT_FILE" "$WEB_FILE"; do
  if [[ ! -f "$file" ]]; then
    echo "ERROR: No existe $file"
    exit 1
  fi

  mapfile -t active_lines < <(sed 's/\r$//' "$file" | sed '/^\s*#/d;/^\s*$/d')

  if [[ "${#active_lines[@]}" -ne 1 ]]; then
    echo "ERROR: $file debe tener exactamente 1 línea activa; tiene ${#active_lines[@]}"
    exit 1
  fi

  line="${active_lines[0]}"
  if [[ ! "$line" =~ $EXPECTED_REGEX ]]; then
    echo "ERROR: Formato inválido en $file"
    echo "Línea encontrada: $line"
    echo "Formato esperado: google.com, pub-XXXXXXXXXXXXXXXX, DIRECT, f08c47fec0942fa0"
    exit 1
  fi

done

if ! cmp -s "$ROOT_FILE" "$WEB_FILE"; then
  echo "ERROR: $ROOT_FILE y $WEB_FILE no coinciden."
  echo "Sugerencia: cp $ROOT_FILE $WEB_FILE"
  exit 1
fi

echo "OK: app-ads.txt encontrado y con formato correcto en ambos archivos."
