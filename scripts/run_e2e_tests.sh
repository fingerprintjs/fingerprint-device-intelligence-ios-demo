#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_ABS_PATH="$(cd "$(dirname "$0")" &>/dev/null && pwd -P)"

readonly XCODE_PROJECT="$SCRIPT_ABS_PATH/../FingerprintProDemo.xcodeproj"
readonly XCODE_SCHEME="FingerprintProDemo"

readonly PLATFORM_IOS="iOS Simulator,name=iPhone 16 Pro"

readonly RESULTS_BUNDLE="E2ETestResults"

rm -rf "${RESULTS_BUNDLE}" "${RESULTS_BUNDLE}.xcresult"

xcodebuild clean test \
    -project "$XCODE_PROJECT" \
    -scheme "$XCODE_SCHEME" \
    -destination platform="$PLATFORM_IOS" \
    -resultBundlePath "$RESULTS_BUNDLE" \
    -skipPackagePluginValidation \
    API_KEY=$API_KEY \
    REGION=$REGION \
    | xcbeautify
