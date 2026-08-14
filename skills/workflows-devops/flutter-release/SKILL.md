---
name: flutter-release
description: >
  Use this skill when preparing, building, and publishing Flutter applications to Google Play Store and Apple App Store. Covers versioning, signing, release builds, store metadata, and post-release monitoring. Do not use for CI/CD pipeline setup (use flutter-ci-cd).
triggers:
  - "Prepare and publish app to Play Store or App Store"
  - "Configure Fastlane, app signing, and keystores"
  - "Build release appbundle or ipa binaries"
negative_triggers:
  - "CI/CD pipeline configuration"
  - "Git branching workflow"
---

# Flutter Release Automation & Store Publishing

## Purpose

Automate and standardize release build generation, code signing, obfuscation, and deployment for Google Play Store and Apple App Store.

## Store Release Requirements Matrix

| Parameter | Android (Google Play) | iOS (Apple App Store) |
|---|---|---|
| **Build Command** | `flutter build appbundle --release` | `flutter build ipa --release` |
| **Output Artifact** | `build/app/outputs/bundle/release/app-release.aab` | `build/ios/ipa/*.ipa` |
| **Code Signing** | `key.properties` + Java Keystore (`.jks` / `.keystore`) | Apple Developer Certificate + Provisioning Profile |
| **Obfuscation** | `--obfuscate --split-debug-info=symbols/` | Enabled by default in Xcode release scheme |
| **Automation tool** | Fastlane (`fastlane supply`) | Fastlane (`fastlane pilot` / `deliver`) |

## Android Release Configuration (`key.properties` & `build.gradle.kts`)

```properties
# android/key.properties (DO NOT COMMIT TO GIT)
storePassword=MY_SECRET_STORE_PASSWORD
keyPassword=MY_SECRET_KEY_PASSWORD
keyAlias=uploadKey
storeFile=../upload-keystore.jks
```

```kotlin
// android/app/build.gradle.kts
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}
```

## Fastlane Release Automation Script (`android/fastlane/Fastfile` & `ios/fastlane/Fastfile`)

```ruby
# android/fastlane/Fastfile
default_platform(:android)

platform :android do
  desc "Deploy a new internal build to Google Play Store"
  lane :deploy_internal do
    sh("flutter build appbundle --release --build-number=#{ENV['BUILD_NUMBER']}")
    upload_to_play_store(
      track: 'internal',
      aab: '../build/app/outputs/bundle/release/app-release.aab',
      skip_upload_apk: true
    )
  end
end
```

```ruby
# ios/fastlane/Fastfile
default_platform(:ios)

platform :ios do
  desc "Push a new beta build to TestFlight"
  lane :beta do
    sh("flutter build ipa --release --build-number=#{ENV['BUILD_NUMBER']}")
    upload_to_testflight(
      ipa: "../build/ios/ipa/*.ipa"
    )
  end
end
```

## Production Release Checklist

- [ ] Version and build number updated in `pubspec.yaml` (`version: 1.2.0+42`)
- [ ] Android `key.properties` generated and excluded in `.gitignore`
- [ ] Obfuscation flag configured for sensitive apps (`flutter build appbundle --obfuscate --split-debug-info=symbols/android`)
- [ ] ProGuard / R8 rules configured in `android/app/proguard-rules.pro`
- [ ] iOS App Store distribution certificate and provisioning profile active
- [ ] Fastlane deployment script executed and verified in TestFlight / Play Console Internal Track

## Related Skills
- `flutter-ci-cd` — Automated CI integration
- `flutter-app-size` — Binary size optimization before release
- `flutter-security` — Release hardening and obfuscation

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
