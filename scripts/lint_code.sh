#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_ABS_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"

readonly OPTION_STRICT="--strict"

readonly PROJECT_ROOT_PATH="$SCRIPT_ABS_PATH/.."

readonly SWIFT_FORMAT_CONFIG_PATH="./.swift-format"
readonly SWIFT_FORMAT_INPUT_FILENAMES="./FingerprintProDemo"

STRICT_MODE=false

function setup_homebrew() {
    local -r homebrew_arm_path="/opt/homebrew/bin/brew"
    local -r homebrew_x86_path="/usr/local/bin/brew"

    if [[ ! -f "$homebrew_arm_path" ]]
    then
        if [[ ! -f "$homebrew_x86_path" ]]
        then
            return 1
        fi

        return 0
    fi

    # On Apple Silicon machines, Homebrew requires additional setup
    eval "$("$homebrew_arm_path" shellenv)"
}

function swift_format_missing() {
    local -r msg="'swift-format' command not found. Run \`make homebrew\` to install required dependencies."

    if [[ "$STRICT_MODE" == true ]]
    then
        echo "error: $msg" 1>&2
        exit 1
    else
        echo "warning: $msg"
        exit 0
    fi
}

function swift_format_lint() {
    if [[ "$STRICT_MODE" == true ]]
    then
        swift-format lint \
                --configuration "$SWIFT_FORMAT_CONFIG_PATH" \
                --recursive \
                --parallel \
                --strict \
                $SWIFT_FORMAT_INPUT_FILENAMES
    else
        swift-format lint \
                --configuration "$SWIFT_FORMAT_CONFIG_PATH" \
                --recursive \
                --parallel \
                $SWIFT_FORMAT_INPUT_FILENAMES
    fi
}

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    "$OPTION_STRICT")
        shift
        STRICT_MODE=true
        ;;
    *)
        break
        ;;
esac
done

if ! setup_homebrew
then
    echo "error: Homebrew not installed. Run \`make homebrew\` to install required dependencies." 1>&2
    exit 1
fi

if ! command -v swift-format &>/dev/null
then
    swift_format_missing
fi

cd "$PROJECT_ROOT_PATH"

swift_format_lint
