import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/models/auth/current_user.dart';
import 'package:spiral_notebook/persistence/hive_data_store.dart';
import 'package:spiral_notebook/services/auth_service.dart';

class CurrentUserManager extends StateNotifier<CurrentAuthUser> {
  final HiveDataStore dataStore;

  CurrentUserManager({
    required CurrentAuthUser currentUser,
    required this.dataStore,
  }) : super(currentUser);

  void refreshWithJson(Map<String, dynamic> json) {
    state = CurrentAuthUser.fromJson(json);
    dataStore.setCurrentUser(currentUser: state);
  }

  Future<dynamic> syncCurrentUser() async {
    final AuthService _auth = AuthService();

    bool syncSuccess = false;

    final userResult = await _auth.fetchUserDetails();

    syncSuccess = (userResult != null);

    if (syncSuccess) {
      state = CurrentAuthUser.fromJson(userResult);
      dataStore.setCurrentUser(currentUser: state);
    }
  }

  void reset() {
    state = CurrentAuthUser();
    dataStore.clearCurrentUser();
  }
}

final currentUserProvider = StateNotifierProvider<CurrentUserManager, CurrentAuthUser>((ref) {
  throw UnimplementedError();
});
