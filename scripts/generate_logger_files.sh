#!/usr/bin/env bash
set -euo pipefail

FOLDER="${PROJECT_DIR}/FingerprintProDemo/Generated"
FILE="${FOLDER}/Confidential.generated.swift"

if [[ "${CONFIGURATION:-}" == "Release" ]]; then
    
	if ! command -v swift-logger >/dev/null 2>&1; then
		echo "ERROR: swift-logger is not installed." >&2
		exit 1
	fi

	mkdir -p "$FOLDER"
	swift-logger --configuration confidential.yml --output "$FILE"

else
    
    if [[ -f "$FILE" ]]; then
        echo "" > "$FILE"
    fi
fi
