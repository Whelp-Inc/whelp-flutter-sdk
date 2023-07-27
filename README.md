# Whelp Flutter Live Chat Package

[![Pub Version](https://img.shields.io/pub/v/whelp_flutter_sdk)](https://pub.dev/packages/whelp_flutter_sdk)
[![License](https://img.shields.io/github/license/your_username/whelp_flutter_sdk)](https://github.com/Whelp-Inc/whelp-flutter-sdk/blob/main/LICENSE)

Whelp Flutter Live Chat Package is a Flutter library that allows you to integrate a live chat feature into your Flutter applications using the Whelp service.

## Features

- Display a live chat interface provided by the Whelp.
- Authenticate users for live chat functionality.
- Customizable for tailoring the live chat interface to your app's branding.

## Installation

To use this package, add `whelp_flutter_sdk` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  whelp_flutter_sdk: ^0.1.0
```

Then, run flutter pub get in your terminal to install the package.

## Usage

To use the Whelp Flutter Live Chat Package, follow these steps:

Import the necessary libraries:

1. Import the necessary libraries:

```dart 
import 'package:whelp_flutter_sdk/whelp_flutter_sdk.dart';
```

2. Create a `WhelpUser`` instance with user information for authentication:
    
```dart
WhelpUser user = WhelpUser(
  fullName: 'John Doe',
  phoneNumber: '+1234567890',
  language: 'EN',
);
```

3. Create a `WhelpConfig`` instance with your Whelp application ID and API key:
    
```dart
WhelpConfig config = WhelpConfig(
  appId: 'your_app_id',
  apiKey: 'your_api_key',
  deviceToken: 'fcm_token'
  disableMoreButton: true,
);
```

4. Create a `WhelpView` widget and pass the user and config as parameters and place it in your app's widget tree:

```dart
WhelpView(
  user: user,
  config: config,
)
```

5. Run the app, and the Whelp live chat interface will be displayed.

## Example

For a more detailed example, check the example directory in this repository.

## Important Note

To use the live chat functionality, you must sign up for the Whelp and obtain your application ID and API key. Visit Whelp's official website to create an account and get started.

## License
This package is open-source and released under the MIT License.

## Issues and Contributions

Please report any issues or feature requests on the GitHub repository. Contributions are welcome! If you want to contribute to this project, create a pull request, and we'll review it together.