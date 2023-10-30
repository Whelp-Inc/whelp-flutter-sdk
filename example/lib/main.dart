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
        colorSchemeSeed: whelpColor,
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
  late final TextEditingController _appIdController;
  late final TextEditingController _apiKeyController;
  late final TextEditingController _deviceIdController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _languageController;
  late final TextEditingController _emailController;
  late final TextEditingController _headerTitleController;
  IdentityIdentifier? _identifier;
  bool disableEmojiPicker = true;

  @override
  void initState() {
    super.initState();

    _appIdController = TextEditingController();
    _apiKeyController = TextEditingController();
    _deviceIdController = TextEditingController(
      text: '1234567890',
    );
    _fullNameController = TextEditingController(
      text: 'John Doe',
    );
    _phoneNumberController = TextEditingController(
      text: '+15555555555',
    );
    _languageController = TextEditingController(
      text: 'EN',
    );
    _emailController = TextEditingController(
      text: 'john@doe.com',
    );
    _headerTitleController = TextEditingController(
      text: 'Custom Header Title',
    );
    _identifier = IdentityIdentifier.email;
  }

  @override
  void dispose() {
    _appIdController.dispose();
    _apiKeyController.dispose();
    _deviceIdController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _languageController.dispose();
    _emailController.dispose();
    _headerTitleController.dispose();
    super.dispose();
  }

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TextField(
                controller: _headerTitleController,
                labelText: 'Header Title',
              ),
              const SizedBox(height: 16.0),
              _TextField(
                controller: _appIdController,
                labelText: 'App ID',
              ),
              const SizedBox(height: 16.0),
              _TextField(
                controller: _apiKeyController,
                labelText: 'API Key',
              ),
              const SizedBox(height: 16.0),
              _TextField(
                controller: _deviceIdController,
                labelText: 'Device ID',
              ),
              const SizedBox(height: 16.0),
              _TextField(
                controller: _fullNameController,
                labelText: 'Full Name',
              ),
              const SizedBox(height: 16.0),
              _TextField(
                controller: _languageController,
                labelText: 'Language',
              ),
              const SizedBox(height: 16.0),
              _TextField(
                controller: _phoneNumberController,
                labelText: 'Phone Number',
              ),
              const SizedBox(height: 16.0),
              _TextField(
                controller: _emailController,
                labelText: 'Email',
              ),
              const SizedBox(height: 16.0),
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  showMenu<IdentityIdentifier>(
                    context: context,
                    position: const RelativeRect.fromLTRB(0, 0, 0, 0),
                    items: const [
                      PopupMenuItem(
                        value: IdentityIdentifier.email,
                        child: Text('E-mail'),
                      ),
                      PopupMenuItem(
                        value: IdentityIdentifier.phoneNumber,
                        child: Text('Phone Number'),
                      ),
                    ],
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _identifier = value;
                      });
                    }
                  });
                },
                title: const Text('Identity with:'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _identifier == IdentityIdentifier.email
                          ? 'Email'
                          : 'Phone Number',
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              SwitchListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Disable Emoji Picker',
                  style: TextStyle(fontSize: 16.0),
                ),
                value: disableEmojiPicker,
                onChanged: (value) {
                  setState(() {
                    disableEmojiPicker = value;
                  });
                },
              ),
              const SizedBox(height: 32.0),
              Center(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 32.0,
                    ),
                  ),
                  onPressed: () {
                    final config = WhelpConfig(
                      appId: _appIdController.text,
                      apiKey: _apiKeyController.text,
                      deviceId: _deviceIdController.text,
                      disableEmojiPicker: disableEmojiPicker,
                      headerTitle: _headerTitleController.text,
                    );
                    final user = WhelpUser(
                      fullName: _fullNameController.text,
                      phoneNumber: _phoneNumberController.text,
                      language: _languageController.text,
                      email: _emailController.text,
                      identifier: _identifier!,
                    );

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return _WhelpPage(
                            config: config,
                            user: user,
                          );
                        },
                      ),
                    );
                  },
                  label: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Open Whelp',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  icon: const Icon(Icons.open_in_new),
                ),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        labelText: labelText,
        border: const UnderlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}

class _WhelpPage extends StatelessWidget {
  const _WhelpPage({
    required this.config,
    required this.user,
  });

  final WhelpConfig config;
  final WhelpUser user;

  @override
  Widget build(BuildContext context) {
    return WhelpScaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Bizə yazın'),
      ),
      config: config,
      user: user,
      loadingBuilder: (BuildContext context) {
        return const Center(
          child: LinearProgressIndicator(),
        );
      },
      onUrlClick: (String url) {
        debugPrint('onUrlClick: $url');
      },
    );
  }
}
