import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whelp_flutter_sdk/src/whelp_service.dart';
import 'package:whelp_flutter_sdk/whelp_flutter_sdk.dart';

/// WhelpView is a Flutter widget that provides a WebView for displaying the Whelp live chat interface.
class WhelpView extends StatefulWidget {
  /// Creates a new instance of WhelpView.
  ///
  /// The [user] parameter is required and represents the user's information for authentication.
  /// The [config] parameter is required and holds the configuration settings for the Whelp SDK.
  const WhelpView({
    Key? key,
    required this.user,
    required this.config,
    this.loadingBuilder,
  }) : super(key: key);

  /// The user's information required for authentication with the Whelp service.
  final WhelpUser user;

  /// The configuration settings for the Whelp SDK.
  final WhelpConfig config;

  /// A builder for the loading indicator widget.
  final WidgetBuilder? loadingBuilder;

  @override
  State<WhelpView> createState() => _WhelpViewState();
}

class _WhelpViewState extends State<WhelpView> {
  late final WebViewController controller;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    // Call the authentication process after the widget is built.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _authenticateUser();
    });
  }

  /// Authenticates the user with the Whelp service and loads the chat interface in the WebView.
  Future<void> _authenticateUser() async {
    // Show loading indicator while authenticating.
    setState(() => _loading = true);

    // Retrieve the URL to the live chat interface through WhelpService.
    final url = await WhelpService.instance.authenticate(
      disableMoreButton: widget.config.disableMoreButton,
      fullName: widget.user.fullName,
      phoneNumber: widget.user.phoneNumber,
      language: widget.user.language,
      appId: widget.config.appId,
      apiKey: widget.config.apiKey,
      deviceToken: widget.config.deviceToken,
    );

    // Load the chat interface in the WebView.
    await controller.loadRequest(Uri.parse(url));

    // Hide loading indicator after authentication is complete.
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator or the WebView based on the _loading flag.
    return _loading
        ? widget.loadingBuilder?.call(context) ??
            const Center(
              child: CircularProgressIndicator.adaptive(),
            )
        : WebViewWidget(
            controller: controller,
          );
  }
}
