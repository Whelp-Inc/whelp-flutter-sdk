import 'package:flutter/material.dart';
import 'package:whelp_flutter_sdk/whelp_flutter_sdk.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Support',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: WhelpView(
          config: WhelpConfig(
            appId: 'your_app_id',
            apiKey: 'your_api_key',
            deviceToken: 'fcm_token',
            disableMoreButton: true,
          ),
          user: WhelpUser(
            fullName: 'John Doe',
            phoneNumber: '+1234567890',
            language: 'EN',
          ),
        ),
      ),
    );
  }
}
