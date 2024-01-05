import 'package:spiral_notebook/api/eqis_api.dart';
import 'package:spiral_notebook/models/contact/contact_info.dart';

class ContactService {
  final _auth = EqisAPI();

  Future<ContactInfo> getContactInfo() async {
    // provide passthru for isLoggedIn, protect widgets from API
    final dynamic responseData = await _auth.getContactInfo();

    ContactInfo _contactInfo = ContactInfo();

    if (responseData.containsKey('email'))
      _contactInfo.setEmail(responseData['email']);

    if (responseData.containsKey('phone'))
      _contactInfo.setPhone(responseData['phone']);

    return _contactInfo;
  }
}
