import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spiral_notebook/local_config.dart';
import 'package:spiral_notebook/models/auth/current_user.dart';
import 'package:spiral_notebook/providers/current_user_provider.dart';
import 'package:spiral_notebook/providers/sync_timestamp_provider.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class SettingsAboutScreen extends ConsumerStatefulWidget {
  const SettingsAboutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsAboutScreen> createState() => _SettingsAboutScreenState();
}

class _SettingsAboutScreenState extends ConsumerState<SettingsAboutScreen> {

  late CurrentAuthUser currentUser;
  late PackageInfo _packageInfo;
  late String syncTime;

  @override
  void initState() {
    super.initState();
    currentUser = ref.read(currentUserProvider);
    DateTime syncTimeRaw = ref.read(syncTimestampProvider);
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    syncTime = formatter.format(syncTimeRaw);
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    _packageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown',
      buildSignature: 'Unknown',
    );
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

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
        title: Text('About'.toUpperCase()),
        backgroundColor: primaryButtonBlue,
        actions: null,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _SectionHeading(label: 'Profile'),
                  _SectionItem(label: 'Username', value: currentUser.myUser!.username),
                  _SectionItem(label: 'Email', value: currentUser.myUser!.email),
                  _SectionItem(label: 'Role', value: currentUser.myUser!.roleName),
                  _SectionItem(label: 'Date Created', value: currentUser.myUser!.formattedDateCreated),
                  _SectionItem(label: 'Last Sync', value: syncTime),
                  Divider(thickness: 2.0),
                  _SectionHeading(label: 'Diagnostic'),
                  _SectionItem(label: 'App Cache Version', value: currentAppDataVersion),
                  _SectionItem(label: 'App Version', value: _packageInfo.version),
                  _SectionItem(label: 'App Build Number', value: _packageInfo.buildNumber),
                  _SectionItem(label: 'OS Platform', value: Platform.operatingSystem),
                  _SectionItem(label: 'OS Version', value: Platform.operatingSystemVersion),
                ],
              ),
            ),
          ),
        );
      })
    );
  }
}

class _SectionItem extends StatelessWidget {
  const _SectionItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontStyle: FontStyle.italic,
          )),
          SelectableText(value),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(label, style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      )),
    );
  }
}
