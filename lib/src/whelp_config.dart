const whelpBaseUrl = 'https://widget-api.getwhelp.com';

class WhelpConfig {
  const WhelpConfig({
    required this.appId,
    required this.apiKey,
    this.deviceId,
    this.disableMoreButton = true,
    this.disableEmojiPicker = true,
    this.disableSounds,
    this.headerTitle,
    this.onLog,
    this.activeStatus,
    this.awayStatus,
  }) : baseUrl = whelpBaseUrl;

  const WhelpConfig.onPremise({
    required this.appId,
    required this.apiKey,
    required this.baseUrl,
    this.deviceId,
    this.disableMoreButton = true,
    this.disableEmojiPicker = true,
    this.disableSounds,
    this.headerTitle,
    this.onLog,
    this.activeStatus,
    this.awayStatus,
  });

  final String appId;
  final String apiKey;
  final String? deviceId;
  final bool disableMoreButton;
  final bool disableEmojiPicker;
  final bool? disableSounds;
  final String? headerTitle;
  final Function(String message)? onLog;
  final String? activeStatus;
  final String? awayStatus;
  final String baseUrl;
}
