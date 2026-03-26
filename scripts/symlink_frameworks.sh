#!/usr/bin/env bash
set -euo pipefail

# Only run for Release builds
[[ "${CONFIGURATION:-}" == "Release" ]] || exit 0

FRAMEWORKS_DIR="${PROJECT_DIR}/SwiftLoggerDependencies/frameworks"
STAGING="${BUILD_DIR}/FrameworkStaging"
mkdir -p "$STAGING"

case "$PLATFORM_NAME" in
  iphoneos)         SLICE="ios-arm64" ;;
  iphonesimulator)  SLICE="ios-arm64_x86_64-simulator" ;;
  appletvos)        SLICE="tvos-arm64" ;;
  appletvsimulator) SLICE="tvos-arm64_x86_64-simulator" ;;
esac

for fw in LoggerKit LoggerCore LoggerUtils; do
  ln -sfh \
    "${FRAMEWORKS_DIR}/${fw}.xcframework/${SLICE}/${fw}.framework" \
    "${STAGING}/${fw}.framework"
done
