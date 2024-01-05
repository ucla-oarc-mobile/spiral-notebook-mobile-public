import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/contact/contact_info_element.dart';
import 'package:spiral_notebook/models/contact/contact_info.dart';
import 'package:spiral_notebook/services/contact_service.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            tooltip: "Back",
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Contact'.toUpperCase()),
          backgroundColor: primaryButtonBlue,
          actions: null,
        ),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(22.0, 20.0, 22.0, 30.0),
                      child: Center(
                        child: Text(
                          'Contact Information',
                          key: const Key('contact_information'),
                          style: TextStyle(
                            fontSize: 16.0,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder<ContactInfo>(
                      future: ContactService().getContactInfo(),
                      builder: (BuildContext context,
                          AsyncSnapshot<ContactInfo> snapshot) {
                        String email = '';
                        String phone = '';

                        if (snapshot.hasData) {
                          email = snapshot.data!.email;
                          phone = snapshot.data!.phone;
                        }

                        if (email == '') email = ContactInfo.defaultEmail;
                        if (phone == '') phone = ContactInfo.defaultPhone;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ContactInfoElement('Email', email),
                            // ContactInfoElement('Phone', phone)
                          ],
                        );
                      },
                    ),
                  ]),
            ),
          );
        }));
  }
}
