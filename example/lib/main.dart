import 'package:flutter/material.dart';
import 'package:whelp_flutter_sdk/whelp_flutter_sdk.dart';

const whelpColor = Color(0xff194856);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whelpColor,
      appBar: AppBar(
        backgroundColor: whelpColor,
        centerTitle: true,
        title: Image.network(
          'https://whelp.co/blog/content/images/2023/01/Untitled-design-2-.png',
          height: 24.0,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          child: SafeArea(
            child: WhelpView(
              config: WhelpConfig(
                appId: 'app_id',
                apiKey: 'api_key',
                deviceId: 'device_id',
                disableMoreButton: true,
              ),
              user: WhelpUser(
                fullName: 'John Doe',
                phoneNumber: '+1234567890',
                language: 'EN',
                email: 'john@doe.com',
                identifier: IdentityIdentifier.email,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
