# mejlis_digital_hub

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Release signing (Android)

Release builds are signed with the commission's release key and **fail without
it**; the debug key is never used for a release.

1. Create the keystore once, outside the repository, and store it and its
   passwords somewhere safe (losing it means the app can no longer be updated
   on Google Play):

   ```sh
   keytool -genkeypair -v -keystore D:/Coop/zakat-release.jks -storetype PKCS12 -keyalg RSA -keysize 4096 -validity 10000 -alias zakat-release
   ```

2. Copy `android/key.properties.example` to `android/key.properties`
   (git-ignored) and fill in the path, alias and passwords.

3. Build: `flutter build appbundle --release` (or `apk`).

Check the signature with Android build-tools' `apksigner` (`keytool` can't
read v2 signatures):
`apksigner verify --print-certs build/app/outputs/flutter-apk/app-release.apk`.
The signer must be the commission's certificate, never `CN=Android Debug`.
