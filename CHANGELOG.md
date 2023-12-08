## 0.5.0

- Fix camera not showing up as a media source on `Android`.
- (Yet again) Update README and add documentation for native iOS applications.

## 0.4.3

- (Yet again) Update README and add documentation for native iOS applications.

## 0.4.2

- Update README and add documentation for native iOS applications.

## 0.4.1

- Added an interactive example app using which you can play around with the SDK/Live Chat.
- Fix: `AppBar` not visible on `Android`.
- Fix: background color until web view is loaded.

## 0.4.0

- Fix: Media picker not working on `Android`.
- *KIND OF BREAKING CHANGE*: The SDK no longer handles external links: if you want to open some external links on browser, you need to handle it yourself. Use `WhelpScaffold#onUrlClick` property which takes a `Function(String)` as a parameter. This is done to give you more control over the external links and give you the ability to do deep linking.
- Want to disable sounds? Use `WhelpConfig#disableSounds` property. By default, on `iOS`, sounds are disabled and on `Android`, sounds are enabled. This is because on `iOS` the sound gets stuck on the media player which is not a good UX.
- Want to change the title of the chat screen? Use `WhelpConfig#headerTitle` property. By default, it is set to `Bizdən nəsə soruşun və ya fikrinizi bölüşün`.

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
