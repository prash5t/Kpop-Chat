#!/usr/bin/env bash
# Run kpopchat in debug. Always passes --dart-define-from-file=.env.json so
# the Mixpanel token + AdMob ids + Telegram bot creds + Firebase init values
# land in the build per awarself env policy.
#
# ---------------------------------------------------------------------------
# Copy-paste alternatives (run from apps/kpopchat/):
#
#   # Debug, default device:
#   # flutter run --dart-define-from-file=.env.json
#
#   # Debug, specific device:
#   # flutter run --dart-define-from-file=.env.json -d <deviceId>
#
#   # Profile mode:
#   # flutter run --dart-define-from-file=.env.json --profile
#
#   # Release mode (run on attached device):
#   # flutter run --dart-define-from-file=.env.json --release
#
# Without --dart-define-from-file=.env.json, every String.fromEnvironment(...)
# returns "" — AdMob falls back to test ads (Env.useTestAds defensive check),
# Mixpanel skips init, Telegram notifier no-ops, Firebase init fails on the
# manual-init path. So always go through this script for parity with prod.
# ---------------------------------------------------------------------------
set -e
cd "$(dirname "$0")/.."
if [ ! -f .env.json ]; then
  echo "error: .env.json missing — copy .env.json.example and fill in values."
  echo "       (Mixpanel + AdMob + Telegram + Firebase — see lib/env.dart for the schema.)"
  exit 1
fi
if [ ! -f android/app/google-services.json ]; then
  echo "error: android/app/google-services.json missing —"
  echo "       download it from console.firebase.google.com for the kpop-chat-f0a99 project"
  echo "       and place it at android/app/google-services.json."
  exit 1
fi
flutter run --dart-define-from-file=.env.json "$@"
