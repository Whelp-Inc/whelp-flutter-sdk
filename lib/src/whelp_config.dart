class WhelpConfig {
  WhelpConfig({
    required this.appId,
    required this.apiKey,
    this.deviceToken,
    this.disableMoreButton = true,
  });

  final String appId;
  final String apiKey;
  final String? deviceToken;
  final bool disableMoreButton;
}
