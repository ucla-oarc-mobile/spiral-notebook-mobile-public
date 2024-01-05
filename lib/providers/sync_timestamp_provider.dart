import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/persistence/hive_data_store.dart';

class SyncTimestampManager extends StateNotifier<DateTime> {
  final HiveDataStore dataStore;

  SyncTimestampManager({
    required DateTime myTime,
    required this.dataStore,
  }) : super(myTime);

  Future<dynamic> refresh(DateTime newTime) async {
    state = newTime;
    dataStore.setSyncTime(myTime: newTime);
  }

  void reset() {
    state = DateTime.now();
    dataStore.clearSyncTime();
  }
}

final syncTimestampProvider = StateNotifierProvider<SyncTimestampManager, DateTime>((ref) {
  throw UnimplementedError();
});
