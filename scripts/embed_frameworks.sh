#!/usr/bin/env bash
set -euo pipefail

# Only run for Release builds
[[ "${CONFIGURATION:-}" == "Release" ]] || exit 0

readonly SRC_ROOT="${PROJECT_DIR}/SwiftLoggerDependencies/frameworks"
readonly DEST="${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

mkdir -p "${DEST}"

log() {
  echo "[Embed XCFrameworks] $*"
}

die() {
  echo "ERROR: $*" >&2
  exit 1
}

sign_framework() {
  local framework="$1"

  log "  -> Signing: $(basename "$framework")"

  /usr/bin/codesign \
    --force \
    --sign "${EXPANDED_CODE_SIGN_IDENTITY}" \
    --preserve-metadata=identifier,entitlements \
    "$framework"
}


platform_slice() {
  local platform="$1"

  case "$platform" in
    iphoneos)         echo "ios-arm64" ;;
    iphonesimulator)  echo "ios-arm64_x86_64-simulator" ;;
    appletvos)        echo "tvos-arm64" ;;
    appletvsimulator) echo "tvos-arm64_x86_64-simulator" ;;
    *)                die "Unsupported platform: ${platform}" ;;
  esac
}

embed_xcframework() {
  local name="$1"
  local xcpath="${SRC_ROOT}/${name}.xcframework"
  local slice
  local framework_path

  slice="$(platform_slice "${PLATFORM_NAME}")"

  framework_path="${xcpath}/${slice}/${name}.framework"

  log "Embedding ${name}.xcframework"
  log "  Platform      : ${PLATFORM_NAME}"
  log "  Slice dir     : ${slice}"
  log "  Source        : ${framework_path}"

  [[ -d "${framework_path}" ]] || die "Missing framework: ${framework_path}"

  log "  -> Copying to: ${DEST}"
  rsync -a --delete "${framework_path}" "${DEST}/"
  sign_framework "${DEST}/${name}.framework"
}

frameworks=(
  "LoggerKit"
  "LoggerCore"
  "LoggerUtils"
)

for fw in "${frameworks[@]}"; do
  embed_xcframework "${fw}"
done

log "Done embedding XCFrameworks."
