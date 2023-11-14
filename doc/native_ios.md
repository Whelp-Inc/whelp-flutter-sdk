# Whelp Flutter SDK for native iOS applications

This README provides instructions for adding the Whelp Live Chat Flutter module to an iOS app.

## 📦 Adding Frameworks

1. Open the iOS project in Xcode.
2. Select the target.
3. Select `Build Phases` tab.
4. Click '+' button and select `New Copy Files Phase`.
5. Name the new phase `Embed Frameworks`.
6. Expand the new phase and change destination to `Frameworks`.
7. Drag and drop the Framework files into the new phase. These files are located in `Frameworks` folder of this repository. Use files from `Debug` folder for debug builds and files from `Release` folder for release builds.

For video instructions, see <a href="https://www.youtube.com/watch?v=1p8ZaRlqyq4" target="_blank">video instructions</a>.

## 🚨 Important notes
- For better performance it's recommended to use one `flutterEngine` instance for the whole application not to create a new instance every time you open the chat.

## 📱 Example

The example code below is a minimal example of how to open the chat screen and you can change it to suit your needs as long as you protect the main logic.

```swift
import SwiftUI
import Flutter
import FlutterPluginRegistrant

class FlutterDependencies: ObservableObject {
  let flutterEngine = FlutterEngine(name: "whelp")
  
  init(){
    flutterEngine.run()
    GeneratedPluginRegistrant.register(with: self.flutterEngine);
  }
}

@main
struct MyApp: App {
 @StateObject var flutterDependencies = FlutterDependencies()

  var body: some Scene {
     WindowGroup {
       ContentView().environmentObject(flutterDependencies)
     }
   }
}
```

```swift
import SwiftUI
import Flutter

struct ContentView: View {
  @EnvironmentObject var flutterDependencies: FlutterDependencies
  var body: some View {
    Button("Open Live Chat") {
      startFlutter()
    }
  }

  func startFlutter() {
      guard
          let windowScene = UIApplication.shared.connectedScenes
              .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
          let window = windowScene.windows.first(where: \.isKeyWindow),
          let rootViewController = window.rootViewController
      else { return }

      // Create the FlutterViewController.
      let flutterViewController = FlutterViewController(
          engine: flutterDependencies.flutterEngine,
          nibName: nil,
          bundle: nil
      )
      flutterViewController.modalPresentationStyle = .pageSheet
      flutterViewController.isViewOpaque = false

      // Create a FlutterMethodChannel to send data to Flutter.
      let methodChannel = FlutterMethodChannel(
          name: "whelp",
          binaryMessenger: flutterViewController.binaryMessenger
      )
    
      // Create a dictionary to hold the data to be sent.
      let data: [String: Any] = [
        // Replace with your own App ID and API Key from Whelp.
        "appId": "{appId}",
        "apiKey": "{apiKey}",

        // Title displayed under the header on the chat screen.
        "headerTitle": "Müraciətiniz bizim üçün dəyərlidir 💙",
        
        // User information for authentication.
        "fullName": "John",
        "email": "john@example.com",
        "phoneNumber": "+994501234567",
        "language": "AZ",

        // Identifier is based on which the identity and uniquness of the user is determined: 
        // if matched: previous chats of the user will be loaded, 
        // Else: a new chat will be created.
        "identifier": "email",

        // Can be Firebase Cloud Messaging token or any other unique identifier.
        "deviceId": "{fcm_token}"
      ]

    methodChannel.invokeMethod("configure", arguments: data)

    rootViewController.present(flutterViewController, animated: true)
    
  }

}
```
