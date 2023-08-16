import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

/// Typedef for the LiveChatUrl, representing the URL to the live chat interface.
typedef LiveChatUrl = String;

/// A service class to interact with the Whelp live chat API.
class WhelpService {
  static WhelpService? _instance;

  // Private constructor
  WhelpService._();

  // Public method to access the instance
  static WhelpService get instance {
    _instance ??= WhelpService._();

    return _instance!;
  }

  /// Authenticates the user with the Whelp service and retrieves the URL to the live chat interface.
  ///
  /// The [disableMoreButton] parameter indicates whether the "More" button is disabled in the chat interface.
  ///
  /// The [fullName] parameter represents the full name of the user for authentication.
  ///
  /// The [phoneNumber] parameter is the user's phone number used for authentication.
  ///
  /// The [language] parameter specifies the user's preferred language for the chat interface.
  ///
  /// The [appId] parameter is the Whelp application ID required for authentication.
  ///
  /// The [apiKey] parameter is the Whelp API key required for generating the authentication hash.
  ///
  /// The [deviceId] parameter represents the unique ID of the user's device.
  ///
  /// Returns a Future that completes with the URL to the live chat interface upon successful authentication.
  Future<LiveChatUrl> authenticate({
    required bool disableMoreButton,
    required String fullName,
    required String? phoneNumber,
    required String? email,
    required String? identity,
    required String language,
    required String appId,
    required String apiKey,
    required String? deviceId,
  }) async {
    final endpoint = Uri.parse('https://widget-api.getwhelp.com/sdk/auth');

    final body = {
      'disableMoreButton': disableMoreButton,
      "contact": {
        "fullname": fullName,
        "phone": phoneNumber,
        "email": email,
      },
      'identity': {
        'field': identity,
      },
      'language': language
    };
    final bodyDecoded = jsonEncode(body);

    final hash = _generateWhelpHash(
      body: bodyDecoded,
      appId: appId,
      apiKey: apiKey,
    );

    final deviceOs = defaultTargetPlatform.name;

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'X-APP-ID': appId,
      'X-DEVICE-OS': deviceOs,
      'X-HASH-VALUE': hash,
      if (deviceId != null) 'X-DEVICE-TOKEN': deviceId,
    };

    final result = await http.post(
      endpoint,
      headers: headers,
      body: bodyDecoded,
    );

    return jsonDecode(result.body)['url'];
  }

  /// Generates the authentication hash using the given [body], [appId], and [apiKey].
  ///
  /// The [body] parameter is the JSON-encoded request body used for generating the hash.
  /// The [apiKey] parameter is the Whelp API key required for the HMAC hashing process.
  /// The [appId] parameter is the Whelp application ID used in conjunction with the [apiKey].
  ///
  /// Returns the generated authentication hash as a String.
  String _generateWhelpHash({
    required String body,
    required String apiKey,
    required String appId,
  }) {
    final List<int> bytesData = utf8.encode(body);

    final Hmac hmacSha256 = Hmac(
      sha256,
      utf8.encode('$apiKey$appId'),
    );
    final Digest hash = hmacSha256.convert(bytesData);

    return hash.toString();
  }
}
