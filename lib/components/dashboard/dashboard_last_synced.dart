import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/providers/multi_providers_manager.dart';
import 'package:spiral_notebook/providers/sync_timestamp_provider.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/utilities/loading.dart';
import 'package:spiral_notebook/utilities/time_ago.dart';

class DashboardLastSynced extends ConsumerStatefulWidget {
  const DashboardLastSynced({
    Key? key,
  }) : super(key: key);

  final Duration refreshRate = const Duration(seconds: 29);

  @override
  ConsumerState<DashboardLastSynced> createState() => _DashboardLastSyncedState();
}

class _DashboardLastSyncedState extends ConsumerState<DashboardLastSynced> {
  Timer? _timer;
  late DateTime actualSyncedTime;
  bool autoUpdating = false;

  @override
  void initState() {
    super.initState();
    subscribeToTimer(widget.refreshRate);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void subscribeToTimer(Duration refreshRate) {
    _timer?.cancel();
    _timer = Timer.periodic(refreshRate, (Timer t) {
      setState(() {});
    });
  }

  void checkForAutoUpdate(WidgetRef ref, BuildContext context) async {

    bool widgetIsVisible = false;

    try {
      // attempts to access context could fail - wrap in a try catch
      var currentRoute = ModalRoute.of(context);

      // This ensures the refresh only attempts if this widget is visible to the user.
       widgetIsVisible = currentRoute?.isCurrent == true;

    } catch (e) {
      widgetIsVisible = false;
    }

    if (widgetIsVisible && autoUpdating == false && DateTime.now().difference(actualSyncedTime) > Duration(days: 1)) {
      autoUpdating = true;
      try {
        showLoading(context, 'Refreshing data...');
        final MultiProviderManager multiProviderManager = MultiProviderManager(ref);
        await multiProviderManager.refreshAll();

        dismissLoading(context);

      } catch (e) {
        // don't show an error, silently dismiss the loader if it fails.
        Navigator.pop(context);
      }
      autoUpdating = false;
    }

  }

  @override
  Widget build(BuildContext context) {
    actualSyncedTime = ref.watch(syncTimestampProvider);
    String readableTimestamp = TimeAgo.timeAgoSinceDate(actualSyncedTime);

    // execute on delay, so this Widget can finish rendering before attempting
    // to display any UI updates during auto-update
    Future.delayed(Duration(seconds: 2), () => checkForAutoUpdate(ref, context));

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.refresh, color: primaryButtonBlue),
          SizedBox(width: 8.0),
          Text('Last Synced: $readableTimestamp', textAlign: TextAlign.right),
        ],
      ),
    );
  }
}
