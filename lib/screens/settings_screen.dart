import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/settings/settings_about_screen.dart';
import 'package:spiral_notebook/providers/multi_providers_manager.dart';
import 'package:spiral_notebook/screens/login_screen.dart';
import 'package:spiral_notebook/services/auth_service.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {

  void showAbout() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsAboutScreen()));
  }

  Future<void> confirmLogout() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Log Out"),
            content: Text("Are you sure that you want to logout?"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text("Confirm"),
                  onPressed: () {
                    AuthService _auth = AuthService();
                    try {
                      final MultiProviderManager multiProviderManager = MultiProviderManager(ref);

                      multiProviderManager.resetAll(resetUserData: true);
                      _auth.logout();
                      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
                    } catch (e) {
                      showSnackAlert(context, 'Logout error, please try again later.');
                    }
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.id, (Route<dynamic> route) => false);
                  }),
            ],
          );
        });
  }

  late List<Map<String, dynamic>> settingsItems;

  @override
  void initState() {
    super.initState();

    settingsItems = [
      {
        'label': 'About',
        'action': () {
          showAbout();
        },
      },
      {
        'label': 'Log Out',
        'action': () {
          confirmLogout();
        },
      },
    ];
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder:
        (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: settingsItems.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> settingsItem =
                settingsItems[index];
                return Column(
                  children: [
                    (index == 0)
                        ? SizedBox(height: 8.0)
                        : SizedBox(),
                    GestureDetector(
                      onTap: () {
                        settingsItem['action'].call();
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Semantics(
                        button: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:<Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(settingsItem['label'], style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],),
                        ),
                      ),
                    ),
                    Divider(thickness: 2.0),
                    (index == settingsItems.length - 1 )
                        ? SizedBox(height: 8.0)
                        : SizedBox(),
                  ],
                );
              },
            )
        ),
      );
    });
  }
}
