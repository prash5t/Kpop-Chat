#!/usr/bin/env bash
# Build a release AAB / APK with the .env.json values baked in. The release
# AAB is signed using the upload keystore at
# ~/Prash_M4/awarself-creds/kpopchat/upload-keystore.jks (path resolved via
# android/key.properties). versionCode for the next Play upload must be >=13
# (current Play state shows v12 as the last completed production release).
#
# ---------------------------------------------------------------------------
# Copy-paste alternatives (run from apps/kpopchat/):
#
#   # AAB for Play Store upload (default — what `bash scripts/build_release.sh` produces):
#   # flutter build appbundle --release --dart-define-from-file=.env.json
#
#   # APK for sideload / direct install / sharing with QA testers:
#   # flutter build apk --release --dart-define-from-file=.env.json
#
#   # Split-per-ABI APKs (smaller per device, useful for sideload to old phones):
#   # flutter build apk --release --split-per-abi --dart-define-from-file=.env.json
#
# Without --dart-define-from-file=.env.json, AdMob ships empty unit IDs, the
# Telegram notifier no-ops, and Firebase manual init fails. Defensive
# fallback in lib/env.dart forces test ads when prod IDs are missing, but
# don't ship a release without verifying real ad creatives serve.
#
# Outputs after a successful build:
#   build/app/outputs/bundle/release/app-release.aab     (Play Store)
#   build/app/outputs/flutter-apk/app-release.apk        (sideload)
# ---------------------------------------------------------------------------
set -e
cd "$(dirname "$0")/.."
if [ ! -f .env.json ]; then
  echo "error: .env.json missing — fill in production values before release builds."
  exit 1
fi
if [ ! -f android/app/google-services.json ]; then
  echo "error: android/app/google-services.json missing — download from Firebase console."
  exit 1
fi
if [ ! -f android/key.properties ]; then
  echo "error: android/key.properties missing — release build will fall back to debug signing,"
  echo "       which Play will reject. Restore key.properties pointing at"
  echo "       ~/Prash_M4/awarself-creds/kpopchat/upload-keystore.jks."
  exit 1
fi
TARGET="${1:-appbundle}"
flutter build "$TARGET" --release --dart-define-from-file=.env.json
