/// Represents a user for authentication with the Whelp service.
class WhelpUser {
  /// Creates a new instance of WhelpUser.
  ///
  /// The [fullName] parameter is required and represents the full name of the user.
  /// The [phoneNumber] parameter is required and holds the phone number of the user.
  /// The [language] parameter is required and specifies the language preference of the user.
  WhelpUser({
    required this.fullName,
    required this.phoneNumber,
    required this.language,
  });

  /// The full name of the user.
  final String fullName;

  /// The phone number of the user.
  final String phoneNumber;

  /// The language preference of the user.
  final String language;
}
