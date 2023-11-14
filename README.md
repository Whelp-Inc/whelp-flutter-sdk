# Whelp Live Chat for Flutter

[![Pub Version](https://img.shields.io/pub/v/whelp_flutter_sdk)](https://pub.dev/packages/whelp_flutter_sdk)
[![License](https://img.shields.io/github/license/your_username/whelp_flutter_sdk)](https://github.com/Whelp-Inc/whelp-flutter-sdk/blob/main/LICENSE)

Whelp Flutter Live Chat Package is a Flutter library that allows you to integrate a live chat feature into your Flutter applications using the Whelp service.

For native Android and iOS applications, please refer to the <a href="https://github.com/Whelp-Inc/whelp-flutter-sdk/blob/main/doc/native_android.md" target="_blank">Android</a> and <a href="https://github.com/Whelp-Inc/whelp-flutter-sdk/blob/main/doc/native_ios.md">iOS</a> documentation.

## ⚠️ Note

Before you use the package, you must be enrolled to [Whelp](https://whelp.co) in order to obtain an `APP_ID` and `API_KEY` on which the SDK depends on to function. 

## 🪚 Installation

To use this package, add `whelp_flutter_sdk` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  whelp_flutter_sdk: ^0.4.2
```

Then, run `flutter pub get` in your terminal to install the package.

## ⚙️ Configuration

In order to be able to use media attachments in the live chat, it's required to add the following permissions to your app's `AndroidManifest.xml` for Android and `Info.plist` for iOS:

### Android

```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.CAMERA"/>
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

### iOS

```xml
  <key>NSCameraUsageDescription</key>
  <string>Camera permission is required for live chat media attachments.</string>
  <key>NSPhotoLibraryUsageDescription</key>
  <string>Photo library permission is required for live chat media attachments.</string>
```

## Usage
1. Import the necessary libraries:

```dart 
import 'package:whelp_flutter_sdk/whelp_flutter_sdk.dart';
```

2. Create a `WhelpUser` instance with user information for authentication:
    
```dart
final WhelpUser user = WhelpUser(
  email: 'john@doe.com',
  fullName: 'John Doe',
  phoneNumber: '+1234567890',
  language: 'EN',
  identifier: IdentityIdentifier.email,
);
```

- Here the `identifier` is based on which the identity and uniquness of the user is determined: if matched, previous chats of the user will be loaded, otherwise a new chat will be created.  
- Either of `phoneNumber` and `email` can be null. In case both of them are null you might not be able to user's previous chat history on every new launch.

3. Create a `WhelpConfig` instance with your `APP_ID` and `API_KEY`:
    
```dart
final WhelpConfig config = WhelpConfig(
  appId: 'your_app_id',
  apiKey: 'your_api_key',
  deviceId: '{fcm_token}',
  disableMoreButton: true,
  disableEmojiPicker: true,
  disableSounds: true,
  headerTitle: 'What do you want to talk us about?',
  onLog: (String message) {
    log(message, name: 'WHELP');
  },
  activeStatus: 'We are online',
  awayStatus: 'We are offline',
);
```

- If you couldn't find your `APP_ID` and `API_KEY` credentials on whelp platform, consider contacting the customer support on the <a href="https://whelp.co" target="_blank">website</a> which is also powered by whelp 😎
- Notice that there are two optional parameters that can be used to disable the more button and emoji picker in the live chat interface.
The emoji picker is best disabled on mobile because all emojis are supported by the mobile keyboard. But if you have a good reason to enable it, you can do so by setting the `disableEmojiPicker` parameter to `false`.

4. Create a `WhelpView` widget and pass the user and config as parameters and place it in your app's widget tree:

```dart
WhelpScaffold(
  appBar: AppBar(
    title: Text('Whelp Live Chat'),
  ),
  user: user,
  config: config,
)
```

5. Run the app, and the Whelp live chat interface will be displayed.

## 🕹️ Example

For a more detailed example, check the <a href="https://github.com/whelp/whelp_flutter_sdk" target="_blank">example</a> directory in this repository.

## 📄 License
This package is open-source and released under the MIT License.

## 🙏 Contributing

Please report any issues or feature requests on the <a href="https://github.com/Whelp-Inc/whelp-flutter-sdk" target="_blank">GitHub repository</a>. Contributions are welcome.