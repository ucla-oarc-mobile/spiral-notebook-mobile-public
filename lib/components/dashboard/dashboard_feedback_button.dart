import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardFeedbackButton extends StatelessWidget {
  const DashboardFeedbackButton({Key? key}) : super(key: key);

  static const String feedbackUrl = 'https://tinyurl.com/3r399ja5';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (TapUpDetails details) async {
        String _url = feedbackUrl;
        if (Platform.isAndroid) {
          if (!await launchUrl(Uri.parse(_url),
              mode: LaunchMode.externalApplication)) throw 'Could not launch $_url';
        } else {
          if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.feedback, color: primaryButtonBlue),
            SizedBox(width: 8.0),
            Text('Give Feedback',
            // textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
              color: primaryButtonBlue,
            )),
          ],
        ),
      ),
    );
  }
}
