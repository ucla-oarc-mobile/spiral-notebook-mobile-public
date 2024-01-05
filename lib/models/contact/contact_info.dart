class ContactInfo {
  static String _defaultEmail = 'mobilizelabs@oarc.ucla.edu';
  static String _defaultPhone = '';
  String _email = _defaultEmail;
  String _phone = _defaultPhone;

  static String get defaultEmail => _defaultEmail;
  static String get defaultPhone => _defaultPhone;
  String get email => _email;
  String get phone => _phone;

  void setEmail(String? email) {
    if (email == null || email == '') email = _defaultEmail;
    _email = email;
  }

  void setPhone(String? phone) {
    if (phone == null || phone == '') phone = _defaultPhone;
    _phone = phone;
  }
}
