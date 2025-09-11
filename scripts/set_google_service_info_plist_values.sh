#!/usr/bin/env bash

set -Eeuo pipefail

# Used with release configuration only
[ "${CONFIGURATION}" = "Release" ] || exit 0

readonly CONFIDENTIAL="${PROJECT_DIR}/confidential.yml"
readonly GOOGLE_SERVICE="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/GoogleService-Info.plist"
readonly YQ="/opt/homebrew/bin/yq"
readonly BREW="/opt/homebrew/bin/brew"
readonly PLIST_BUDDY="/usr/libexec/PlistBuddy"

function add_google_service_param() {
    local -r google_service_param="$1"
    local -r confidential_param="$2"

    local -r query=".secrets[] | select(.name == \"${confidential_param}\") | .value"
    local -r value=$("${YQ}" "${query}" "${CONFIDENTIAL}")

    "${PLIST_BUDDY}" -c "Add :${google_service_param} string \"${value}\"" "${GOOGLE_SERVICE}"
}

# Make sure `confidential.yml` and `GoogleService-Info.plist` exist
[ -e "${CONFIDENTIAL}" ] || { echo "error: Missing ${CONFIDENTIAL}"; exit 1; }
[ -e "${GOOGLE_SERVICE}" ] || { echo "error: Missing ${GOOGLE_SERVICE}"; exit 1; }

# Install `yq` if needed
if ! [ -x "$YQ" ]; then
    if ! [ -x "$BREW" ]; then
        echo "error: Homebrew not installed. Run \`make homebrew\` to install required dependencies." 1>&2
        exit 1
    fi
    $BREW install yq
fi

add_google_service_param "API_KEY" "firebaseApiKey"
add_google_service_param "GCM_SENDER_ID" "firebaseGcmSenderId"
add_google_service_param "GOOGLE_APP_ID" "firebaseGoogleAppId"

# Verify `GoogleService-Info.plist` content
"${PLIST_BUDDY}" -c "print" "${GOOGLE_SERVICE}"
