class WhelpConfig {
  WhelpConfig({
    required this.appId,
    required this.apiKey,
    this.deviceId,
    this.disableMoreButton = true,
    this.disableEmojiPicker = true,
  });

  final String appId;
  final String apiKey;
  final String? deviceId;
  final bool disableMoreButton;
  final bool disableEmojiPicker;
}
