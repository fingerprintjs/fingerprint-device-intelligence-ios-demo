#!/usr/bin/env bash
set -euo pipefail

# Only run for Release builds
[[ "${CONFIGURATION:-}" == "Release" ]] || exit 0

if ! command -v swift-logger >/dev/null 2>&1; then
    echo "ERROR: swift-logger is not installed." >&2
    exit 1
fi

swift-logger --configuration confidential.yml --output "${PROJECT_DIR}/FingerprintProDemo/Generated/Confidential.generated.swift"