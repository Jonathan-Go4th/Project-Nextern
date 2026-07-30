# Project Nextern Roadmap & TODO

## PHASE #1 - Modern Splash Screen [COMPLETED]

- [x] **Research & Specifications**:
  - Master Logo Dimensions: 1024 × 1024 px.
  - Android 12+ Splash specs: 1152 × 1152 px canvas with 768 px centered safe area.
  - Native iOS & Android Launch Screen configuration via `flutter_native_splash`.
  - Brand Palette: Clean light surface `#F8FAFD` with `#3157F6` primary blue accents.
- [x] **Native OS Splash Screen Setup**:
  - Configured `flutter_native_splash` in `pubspec.yaml` using `assets/images/nextern_logo.png` and `#F8FAFD` background.
- [x] **Animated Flutter Splash Screen**:
  - Created `SplashScreen` widget ([splash_screen.dart](file:///c:/Users/urpau/Desktop/Nextern_Experiment/lib/screens/splash_screen.dart)) with entrance scale & fade animations (`Curves.easeOutBack`).
  - Added brand gradient glow, modern typography ("NEXTERN"), tagline ("Empowering Future Leaders"), and subtle progress loader.
- [x] **Session & Route Integration**:
  - Set `/splash` as `initialRoute` in [main.dart](file:///c:/Users/urpau/Desktop/Nextern_Experiment/lib/main.dart).
  - Integrated `AppSession.getRole()` in parallel with splash animation to route to `/admin-home`, `/home`, or `/login` smoothly.

---

## PHASE #2 - Code & Asset Cleanup [COMPLETED]
- [x] **Subdirectory Audit & Removal**:
  - Removed temporary assets in `assets/images/`.
  - Removed obsolete widget files and unused imports across `lib/screens/`, `lib/services/`, and `lib/widgets/`.
  - Fixed relative imports in `test/models/` and `test/services/` to standard package imports.
  - Cleaned collection syntax and unused local variables.