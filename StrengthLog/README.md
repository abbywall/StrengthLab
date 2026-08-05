# StrengthLog iOS MVP

A native SwiftUI iPhone app for selecting strength exercises, logging weight/reps/sets, timing rest periods, and reviewing saved workout history.

## Run it
1. Unzip the project on a Mac.
2. Open `StrengthLog.xcodeproj` in Xcode 16 or later.
3. Select the `StrengthLog` target, then choose your Apple Development Team under Signing & Capabilities.
4. Select an iPhone simulator or connected iPhone and press Run.

## Included
- Searchable exercise picker organized by muscle group
- Add/delete sets and enter weight and reps
- Complete-set button that automatically starts a configurable 30–180 second rest timer
- Pause, resume, and skip rest
- Local workout history stored with UserDefaults
- Workout details and deletion

## Notes
- Minimum target is iOS 17.
- The project intentionally has no third-party dependencies.
- Add an AppIcon asset before App Store distribution. If Xcode warns that AppIcon is missing, remove `ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon` from Build Settings or add an asset catalog.
