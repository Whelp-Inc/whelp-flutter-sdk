import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whelp_flutter_sdk/src/whelp_service.dart';
import 'package:whelp_flutter_sdk/whelp_flutter_sdk.dart';

/// WhelpScaffold is a Flutter widget that provides a WebView for displaying the Whelp live chat interface.
class WhelpScaffold extends StatefulWidget {
  /// Creates a new instance of WhelpScaffold.
  ///
  /// The [user] parameter is required and represents the user's information for authentication.
  /// The [config] parameter is required and holds the configuration settings for the Whelp SDK.
  const WhelpScaffold({
    Key? key,
    required this.user,
    required this.config,
    this.loadingBuilder,
    this.placeholderColor = Colors.white,
    this.appBar,
  }) : super(key: key);

  /// The user's information required for authentication with the Whelp service.
  final WhelpUser user;

  /// The configuration settings for the Whelp SDK.
  final WhelpConfig config;

  /// A builder for the loading indicator widget.
  final WidgetBuilder? loadingBuilder;

  /// The background color of the page until the live chat interface is loaded.
  final Color placeholderColor;

  final PreferredSizeWidget? appBar;

  @override
  State<WhelpScaffold> createState() => _WhelpScaffoldState();
}

class _WhelpScaffoldState extends State<WhelpScaffold> {
  late final WebViewController _controller;
  Uri? _url;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final url = request.url;
            final allow = url.toString().contains('whelp.co') ||
                url.toString().contains('about:srcdoc');

            // If the request is a navigation to the Whelp live chat interface, allow it.
            if (allow) {
              return NavigationDecision.navigate;
            } else {
              // Otherwise, launch the URL in the browser.
              await launchUrl(Uri.parse(url));

              // Prevent all other navigations.
              return NavigationDecision.prevent;
            }
          },
        ),
      )
      ..setBackgroundColor(widget.placeholderColor);

    // Call the authentication process after the widget is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticateUser();
    });
  }

  /// Authenticates the user with the Whelp service and loads the chat interface in the WebView.
  Future<void> _authenticateUser() async {
    // Retrieve the URL to the live chat interface through WhelpService.
    final url = await WhelpService.instance.authenticate(
      disableMoreButton: widget.config.disableMoreButton,
      fullName: widget.user.fullName,
      phoneNumber: widget.user.phoneNumber,
      email: widget.user.email,
      identity: widget.user.identifier == IdentityIdentifier.email
          ? 'email'
          : 'phone',
      language: widget.user.language,
      appId: widget.config.appId,
      apiKey: widget.config.apiKey,
      deviceId: widget.config.deviceId,
    );

    _controller.loadRequest(Uri.parse(url));

    setState(() => _url = Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          if (widget.appBar != null) widget.appBar!,
          Expanded(
            // Show a loading indicator or the WebView based on the _url variable
            child: _url == null
                ? widget.loadingBuilder?.call(context) ??
                    const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                : WebViewWidget(
                    controller: _controller,
                  ),
          ),
          const Divider(
            height: 24.0,
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
