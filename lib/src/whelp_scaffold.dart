import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
    this.onUrlClick,
  }) : super(key: key);

  /// The user's information required for authentication with the Whelp service.
  final WhelpUser user;

  /// The configuration settings for the Whelp SDK.
  final WhelpConfig config;

  /// A builder for the loading indicator widget.
  final WidgetBuilder? loadingBuilder;

  /// The background color of the page until the live chat interface is loaded.
  final Color placeholderColor;

  /// The app bar to display above the live chat interface.
  final PreferredSizeWidget? appBar;

  /// A callback that is called when the user clicks on a URL in the live chat interface.
  final Function(String url)? onUrlClick;

  @override
  State<WhelpScaffold> createState() => _WhelpScaffoldState();
}

class _WhelpScaffoldState extends State<WhelpScaffold> {
  Uri? _url;

  @override
  void initState() {
    super.initState();

    widget.config.onLog?.call('Initializing WhelpScaffold...');

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
      disableEmojiPicker: widget.config.disableEmojiPicker,
      disableSounds: widget.config.disableSounds ??
          defaultTargetPlatform == TargetPlatform.iOS,
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
      headerTitle: widget.config.headerTitle,
      activeStatus: widget.config.activeStatus,
      awayStatus: widget.config.awayStatus,
      onLog: widget.config.onLog,
      baseUrl: widget.config.baseUrl,
    );

    setState(() => _url = Uri.parse(url));

    widget.config.onLog?.call('User authenticated successfully');
  }

  String get _domain {
    final uri = Uri.parse(widget.config.baseUrl);
    final String domain = uri.host.split('.').sublist(1).join('.');

    return domain;
  }

  @override
  Widget build(BuildContext context) {
    return defaultTargetPlatform == TargetPlatform.iOS
        ? Material(
            color: widget.placeholderColor,
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
                      : _WebView(
                          url: _url!,
                          onUrlClick: widget.onUrlClick,
                          domain: _domain,
                        ),
                ),
                const Divider(
                  height: 24.0,
                  color: Colors.transparent,
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: widget.placeholderColor,
            resizeToAvoidBottomInset: true,
            appBar: widget.appBar,
            body: _url == null
                ? widget.loadingBuilder?.call(context) ??
                    const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                : _WebView(
                    url: _url!,
                    onUrlClick: widget.onUrlClick,
                    domain: _domain,
                  ),
          );
  }
}

class _WebView extends StatelessWidget {
  const _WebView({
    required this.url,
    required this.onUrlClick,
    required this.domain,
  });

  final Uri url;
  final Function(String url)? onUrlClick;
  final String domain;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: url),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          transparentBackground: true,
          useShouldOverrideUrlLoading: true,
        ),
      ),
      shouldOverrideUrlLoading: (_, NavigationAction navigationAction) async {
        final url = navigationAction.request.url;

        final allow = url.toString().contains(domain) ||
            url.toString().contains('about:srcdoc');

        // If the request is a navigation to the Whelp live chat interface, allow it.
        if (allow) {
          return NavigationActionPolicy.ALLOW;
        } else {
          // Otherwise, launch the URL in the browser.
          onUrlClick?.call(url.toString());

          // Prevent all other navigations.
          return NavigationActionPolicy.CANCEL;
        }
      },
    );
  }
}
