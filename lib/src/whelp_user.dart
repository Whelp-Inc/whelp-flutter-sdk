/// Represents the type of identity identifier.
enum IdentityIdentifier {
  /// The identifier is an email.
  email,

  /// The identifier is a phone number.
  phoneNumber,
}

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
    required this.email,
    required this.identifier,
  });

  /// The full name of the user.
  final String fullName;

  /// The phone number of the user.
  /// This is optional and can be null.
  final String? phoneNumber;

  /// The language preference of the user.
  final String language;

  /// The email of the user.
  /// This is optional and can be null.
  final String? email;

  /// The identifier type of the user.
  final IdentityIdentifier identifier;
}
