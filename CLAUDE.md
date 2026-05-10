# kpopchat

awarself indie Android app — chat with AI K-pop fan personas, browse a
world map of fans, follow an AI-generated K-pop news feed.
**Inherits all conventions** from the main framework CLAUDE.md at
`../../CLAUDE.md` (this app dir lives at `apps/kpopchat/` inside the main
repo; `apps/` is gitignored as a group).

**Package id:** `com.awarself.kpopchat`
**Play status (2026-05-10):** removed 2024-07-14; last live versionCode 12; revival in progress.
**Architecture:** declared **exempt** from the awarself `presentation/{cubit,screens,widgets}/` convention (mirrors dream_journal exemption). Existing `business_logic/` cubits + `data/repository{,_implementation}/` split already match clean-arch in shape; literal rename was judged churn-only by flutter-architect (see `../../docs/apps/kpopchat/migration-plan.md`).

**Stack:** Flutter (system install), bloc/cubit (`flutter_bloc`), Firebase
(Auth/Firestore/Remote Config/FCM/Crashlytics/Analytics — manual init via
`lib/core/firebase/firebase_options.dart`), Mixpanel, Google Mobile Ads,
`flutter_map` (OpenStreetMap, no API key required), `dash_chat_2`.
**Ads-only — no IAP.** OneSignal and Google Maps SDK have been dropped.

**Layout (current):**
- `lib/business_logic/<feature>_cubit/` — cubits + state classes per feature
- `lib/data/{models,repository,repository_implementation}/` — data layer
- `lib/presentation/{screens,common_widgets}/` — UI
- `lib/core/{constants,firebase,network,routes,themes,utils}/` — infrastructure
- `lib/admin_controls/` — gitignored, dev-only AI-post-generation tooling
- `lib/data/repository/data_filter_repo.dart` — gitignored, dev-only Telegram admin notifier

**Credentials — NEVER commit these:**
- `.env.json` — Mixpanel + AdMob + Telegram + Firebase init values (gitignored). Source of truth for `lib/env.dart`.
- `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` — Firebase config (gitignored).
- `android/key.properties` + the upload keystore (gitignored). The keystore lives outside the repo at `~/Prash_M4/awarself-creds/kpopchat/upload-keystore.jks` (sha256 `fd868673...`); `key.properties` `storeFile` is the absolute path.

`lib/env.dart` is committed and holds **no credential values** — only
`String.fromEnvironment` lookups. `lib/core/constants/{env_keys_constants,google_ads_id}.dart` are now thin facades over `Env` (also committed, no secrets) so existing `EnvKeys.X` and `GoogleAdId.X` callsites keep working unchanged.

Build/run via `scripts/run.sh` or `scripts/build_release.sh` so `--dart-define-from-file=.env.json` is always applied.

**Compliance pages:** https://prash5t.github.io/indie-apps-policies/kpopchat/ (privacy, account-deletion, in-app-economy). In-app pointers are in `lib/core/constants/network_constants.dart`.

See `../../docs/apps/kpopchat/play-state-snapshot.md` for current Play Console state and `../../docs/apps/kpopchat/migration-plan.md` for the revival roadmap.
