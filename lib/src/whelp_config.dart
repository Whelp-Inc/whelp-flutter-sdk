class WhelpConfig {
  WhelpConfig({
    required this.appId,
    required this.apiKey,
    this.deviceId,
    this.disableMoreButton = true,
    this.disableEmojiPicker = true,
    this.disableSounds,
    this.headerTitle,
    this.onLog,
  });

  final String appId;
  final String apiKey;
  final String? deviceId;
  final bool disableMoreButton;
  final bool disableEmojiPicker;
  final bool? disableSounds;
  final String? headerTitle;
  final Function(String message)? onLog;
}
