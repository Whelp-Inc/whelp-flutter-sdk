# Whelp Flutter SDK for native iOS applications

This document describes how to integrate Whelp Flutter SDK into native iOS mobile applications.

## 👟 Before you begin 
Consider all sections below as a guide that you should just read with some popcorn 🍿. At the end check the [🕹️ Example](#-example) section for a complete example and then modify it to suit your architectural needs with some coffee ☕️ if not tea 🍵.

## 📋 Table of Contents

* [📦 Adding Frameworks](#-adding-frameworks)
* [🚨 Important notes](#-important-notes)
* [📞 Communication with the SDK](#-communication-with-the-sdk)
  * [📥 Receiving messages from Flutter](#-receiving-messages-from-flutter)
  * [📤 Sending messages to Flutter](#-sending-messages-to-flutter)
* [🕹️ Example](#-example)
* [📄 License](#-license)
* [🙏 Contributing](#-contributing)

## 📦 Adding Frameworks

First, you need to add the Framework files to your project. For now you need to do this manually by downloading from this <a href="https://drive.google.com/drive/folders/150nBQZJO-1vVcmLxyWVxKhguaPAtD92t?usp=sharing" target="_blank">link</a>. We're working on making this process easier and automated in the future.

After you obtain the Framework files, you need to add them to your project:

1. Open the iOS project in Xcode.
2. Select the target.
3. Select `Build Phases` tab.
4. Click '+' button and select `New Copy Files Phase`.
5. Name the new phase `Embed Frameworks`.
6. Expand the new phase and change destination to `Frameworks`.
7. Drag and drop the Framework files into the new phase. These files are located in `Frameworks` folder of this repository. Use files from `Debug` folder for debug builds and files from `Release` folder for release builds.

For video instructions, see <a href="https://www.youtube.com/watch?v=1p8ZaRlqyq4" target="_blank">video instructions</a>.

## 🚨 Important notes
- For better performance it's recommended to use one `flutterEngine` instance for the whole application and call `flutterEngine.run()` once, not to create a new instance every time you open the live chat.

## 📞 Communication with the SDK
Communication with the SDK is done via `FlutterMethodChannel` and the channel name is `whelp`. Both native and Flutter (in this context Flutter is the Live Chat) sides can send messages to each other via this channel. 

Create a `FlutterMethodChannel` instance and set a `FlutterMethodCallHandler` to it to receive messages from Flutter:

```swift
let methodChannel = FlutterMethodChannel(
    name: "whelp",
    binaryMessenger: flutterViewController.binaryMessenger
)
```

### 📥 Receiving messages from Flutter
To receive messages from Flutter, you need to set a `FlutterMethodCallHandler` to the channel: 

#### - onLog 
Called when the SDK wants to log something. You can use this to log errors or warnings. 

```swift
methodChannel.setMethodCallHandler { call, result in
    if call.method == "onLog" {
        if let arguments = call.arguments as? [String: Any],
            let logMessage = arguments["message"] as? String {
            print(logMessage)
            
            if let stack = arguments["stack"] as? String {
                print(stack)
            }
        }
    }
}
```

#### - close
Called when the user clicks the close button on the chat screen. When received, you should close the chat screen. This is made manually because the SDK doesn't know how you want to close the chat screen, maybe some animations?

```swift
methodChannel.setMethodCallHandler { call, result in
    if call.method == "close" {
        flutterViewController.dismiss(animated: true)
    }
}
```

#### - handleUrl
Called when the user clicks a link in the chat screen. This option is useful if you want some links to be opened in Safari or in your own webview or even deep link to another screen in your app. 

```swift
methodChannel.setMethodCallHandler { call, result in
    if call.method == "handleUrl" {
        if let arguments = call.arguments as? [String: Any],
            let url = arguments["url"] as? String {
            // Handle the url here.
        }
    }
}
```

### 📤 Sending messages to Flutter
To send messages to Flutter, you need to call the `invokeMethod` method of the channel: 

#### - start
This method should be called with data shown below to configure the live chat before opening:

```swift
let data: [String: Any] = [
  // Replace with your own App ID and API Key from Whelp.
  "appId": "{appId}",
  "apiKey": "{apiKey}",

  // Title displayed under the header on the chat screen.
  "headerTitle": "How can we help you?",

  // Status messages displayed on the chat screen.
  "activeStatus": "We are here to help you!",
  "awayStatus": "We are away at the moment",
  
  // User information for authentication.
  "fullName": "Alan Watts",
  "email": "alan@watts.zen"
  "phoneNumber": "+994501234567",
  "language": "EN",

  // Identifier is based on which the identity and uniquness of the user is determined: 
  // if matched: previous chats of the user will be loaded, 
  // Else: a new chat will be created.
  "identifier": "email",

  // Can be Firebase Cloud Messaging token or any other unique identifier.
  "deviceId": "{fcm_token}"
]

methodChannel.invokeMethod("start", arguments: data)
```

## 🕹️ Example

The example code below is a minimal example of how to open the chat screen and you can change it to suit your needs as long as you protect the main logic.

App.swift

```swift
import SwiftUI
import Flutter

@main
struct MyApp: App {
  
  // A flag indicating whether the Flutter engine has been run.
  static var hasFlutterEngineRun = false
  
  // Create a single instance of FlutterEngine.
  private static let flutterEngine = FlutterEngine(name: "whelp")
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(FlutterManager(engine: Self.flutterEngine))
    }
  }
}
```

ContentView.swift

```swift
import SwiftUI
import Flutter
import FlutterPluginRegistrant

struct ContentView: View {
  @EnvironmentObject var flutterManager: FlutterManager
  
  var body: some View {
    NavigationView {
      VStack {
        Button("Open Flutter Module") {
          flutterManager.startFlutter()
        }
      }
      .navigationTitle("Flutter in SwiftUI")
    }
  }
}

// A manager class responsible for handling Flutter-related functionality.
class FlutterManager: ObservableObject {
  // The Flutter engine used to run Flutter code.
  private let flutterEngine: FlutterEngine
  
  // The method channel for communication between Flutter and SwiftUI.
  private var methodChannel: FlutterMethodChannel?
  
  // The root view controller of the SwiftUI app.
  private weak var rootViewController: UIViewController?
  
  // The Flutter view controller used to present the Flutter module.
  private var flutterViewController: FlutterViewController?
  
  // Initializes the FlutterManager with a given Flutter engine.
  init(engine: FlutterEngine) {
    self.flutterEngine = engine
  }
  
  // Starts the Flutter module and presents it when the button is tapped.
  func startFlutter() {
    // Run FlutterEngine only if it hasn't been started
    if !MyApp.hasFlutterEngineRun {
      DispatchQueue.main.async {
        self.flutterEngine.run()
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
        MyApp.hasFlutterEngineRun = true
        self.setupMethodChannel()
      }
    }
    
    guard let windowScene = UIApplication.shared.connectedScenes.first(
      where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }
    ) as? UIWindowScene,
          let window = windowScene.windows.first(where: \.isKeyWindow),
          let rootViewController = window.rootViewController
    else {
      return
    }
    
    self.rootViewController = rootViewController
    
    let data = prepareFlutterData()
    
    DispatchQueue.main.async {
      self.methodChannel?.invokeMethod("start", arguments: data)
      
      // Check if the FlutterViewController has been created
      if self.flutterViewController == nil {
        self.flutterViewController = FlutterViewController(
          engine: self.flutterEngine,
          nibName: nil,
          bundle: nil
        )
      }
      
      rootViewController.present(self.flutterViewController!, animated: true)
    }
  }
  
  // Prepares data to be sent to the Flutter module.
  private func prepareFlutterData() -> [String: Any] {
    return [
      "appId": "{appId}",
      "apiKey": "{apiKey}",
      "headerTitle": "How can we help you?",
      "activeStatus": "We are here to help you!",
      "awayStatus": "We are away at the moment",
      "identifier": "email",
      "fullName": "Alan Watts",
      "email": "alan@watts.zen",
      "phoneNumber": "+994501234567",
      "language": "EN",
      "deviceId": "{fcm_token}"
    ]
  }
  
  // Sets up the method channel for communication with Flutter.
  private func setupMethodChannel() {
    if methodChannel == nil {
      methodChannel = FlutterMethodChannel(
        name: "whelp",
        binaryMessenger: flutterEngine.binaryMessenger
      )
      
      methodChannel?.setMethodCallHandler { [weak self] call, result in
        self?.handleMethodCall(call, result: result)
      }
    }
  }
  
  // Handles method calls from Flutter.
  private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "onLog":
      handleLogCall(call, result: result)
    case "close":
      handleCloseCall(call, result: result)
    case "handleUrl":
      handleUrlCall(call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  // Handles log method calls from Flutter.
  private func handleLogCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if let arguments = call.arguments as? [String: Any],
       let logMessage = arguments["message"] as? String {
      print(logMessage)
      
      if let stack = arguments["stack"] as? String {
        print(stack)
      }
    }
    result(nil)
  }
  
  // Handles close method calls from Flutter.
  private func handleCloseCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    DispatchQueue.main.async {
      self.rootViewController?.dismiss(animated: true, completion: nil)
      // Additional cleanup if needed...

      result(nil)
    }
  }

  // Handles handleUrl method calls from Flutter.
  private func handleUrlCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if let arguments = call.arguments as? [String: Any],
       let url = arguments["url"] as? String {
      // Handle the url here.
    }
    
    result(nil)
  }
}
```

## 📄 License
This package is open-source and released under the MIT License.

## 🙏 Contributing
Please report any issues or feature requests on the <a href="https://github.com/Whelp-Inc/whelp-flutter-sdk" target="_blank">GitHub repository</a>. Contributions are welcome.