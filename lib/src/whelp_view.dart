import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:whelp_flutter_sdk/src/whelp_service.dart';
import 'package:whelp_flutter_sdk/whelp_flutter_sdk.dart';

/// A custom implementation of the ChromeSafariBrowser class that is used to
/// open external links.
class _WhelpChromeSafariBrowser extends ChromeSafariBrowser {}

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
    this.placeholderColor = Colors.white,
  }) : super(key: key);

  /// The user's information required for authentication with the Whelp service.
  final WhelpUser user;

  /// The configuration settings for the Whelp SDK.
  final WhelpConfig config;

  /// A builder for the loading indicator widget.
  final WidgetBuilder? loadingBuilder;

  /// The background color of the page until the live chat interface is loaded.
  final Color placeholderColor;

  @override
  State<WhelpView> createState() => _WhelpViewState();
}

class _WhelpViewState extends State<WhelpView> {
  late final _WhelpChromeSafariBrowser _browser;
  Uri? _url;

  @override
  void initState() {
    super.initState();

    _browser = _WhelpChromeSafariBrowser();

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

    setState(() => _url = Uri.parse(url));
  }

  @override
  void dispose() {
    _browser.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator or the WebView based on the _url variable
    return _url == null
        ? widget.loadingBuilder?.call(context) ??
            const Center(
              child: CircularProgressIndicator.adaptive(),
            )
        : InAppWebView(
            initialUrlRequest: URLRequest(url: _url),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                transparentBackground: true,
                useShouldOverrideUrlLoading: true,
              ),
            ),
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url;

              if (url.toString().contains('whelp.co') ||
                  url.toString().contains('about:srcdoc')) {
                return NavigationActionPolicy.ALLOW;
              } else {
                _browser.open(url: url!);
                return NavigationActionPolicy.CANCEL;
              }
            },
          );
  }
}
