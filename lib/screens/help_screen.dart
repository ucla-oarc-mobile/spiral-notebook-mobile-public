import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/screens/contact_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends ConsumerStatefulWidget {
  HelpScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  void contactUs() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ContactScreen()));
  }

  void giveFeedback() async {
    // give feedback
    String feedbackUrl = 'https://tinyurl.com/3r399ja5';

    String _url = feedbackUrl;
    if (Platform.isAndroid) {
      if (!await launchUrl(Uri.parse(_url),
          mode: LaunchMode.externalApplication)) throw 'Could not launch $_url';
    } else {
      if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
    }
  }

  void showHelp() async {
    // give feedback
    String feedbackUrl =
        'https://github.com/ucla/Spiral-Notebook/wiki/Spiral-Notebook-Mobile-App-User-Guide';

    if (!await launchUrl(Uri.parse(feedbackUrl))) throw 'Could not launch $feedbackUrl';
  }

  late List<Map<String, dynamic>> helpItems;

  @override
  void initState() {
    super.initState();

    helpItems = [
      {
        'label': 'Contact Us',
        'action': () {
          contactUs();
        },
      },
      {
        'label': 'Give Feedback',
        'action': () {
          giveFeedback();
        },
      },
      {
        'label': 'Help',
        'action': () {
          showHelp();
        },
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: helpItems.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> helpItem = helpItems[index];
                    return Column(
                      children: [
                        (index == 0) ? SizedBox(height: 8.0) : SizedBox(),
                        GestureDetector(
                          onTap: () {
                            helpItem['action'].call();
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Semantics(
                            button: true,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22.0, vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(helpItem['label'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(thickness: 2.0),
                        (index == helpItems.length - 1)
                            ? SizedBox(height: 8.0)
                            : SizedBox(),
                      ],
                    );
                  },
                ),
              ])));
    });
  }
}
