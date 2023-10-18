## 0.3.1
- Added `WhelpConfig#disableEmojiPicker` property to disable emoji picker in the chat interface for a better UX. By default, it is set to `true`.

## 0.3.0
- Fixed some keyboard issues for better UX.
- `WhelpView` replaced with `WhelpScaffold`. You can supply your own `AppBar` directly.

## 0.2.2
- Open external links using in-app `SafariViewController` on `iOS` and `ChromeCustomTabs` on `Android`.

## 0.2.1

- Added `email` property to `WhelpUser`
- Added `IdentityIdentifier` to `WhelpUser`: `IdentityIdentifier.email`, `IdentityIdentifier.phoneNumber`
- Added license

## 0.2.0

- Migrate to `flutter_inappwebview` plugin.
- Add examples for media permissions for `iOS` and `Android`.

## 0.1.2

- Breaking change: `deviceToken` is replaced with `deviceId` in `WhelpConfig`.

## 0.1.1

- Fix `Android` launch issue.
- Add `loadingBuilder(context)` property to `WhelpView`.
- Update example app.


## 0.1.0

Initial release of the Whelp Flutter SDK.
