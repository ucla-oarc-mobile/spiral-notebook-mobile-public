import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/models/shared_portfolio/shared_portfolios.dart';
import 'package:spiral_notebook/persistence/hive_data_store.dart';
import 'package:spiral_notebook/services/shared_portfolios_service.dart';

class SharedPortfoliosManager extends StateNotifier<SharedPortfolios> {
  final HiveDataStore dataStore;

  SharedPortfoliosManager({
    required SharedPortfolios sharedPortfolios,
    required this.dataStore,
  }) : super(sharedPortfolios);

  void refreshWithJson(json) {
    state = SharedPortfolios.fromJson(json);
    dataStore.setSharedPortfolios(sharedPortfolios: state);
  }

  void updateWithSharedArtifactJson(Map<String, dynamic> artifactJson) {
    state = state.withUpdatedSingleArtifactJson(artifactJson);
    dataStore.setSharedPortfolios(sharedPortfolios: state);
  }


  Future<dynamic> syncSharedPortfolios() async {
    final SharedPortfoliosService _portfolios = SharedPortfoliosService();

    bool syncSuccess = false;

    final portfoliosResult = await _portfolios.fetchSharedPortfolios();

    syncSuccess = (portfoliosResult != null);

    if (syncSuccess) {
      state = SharedPortfolios.fromJson(portfoliosResult);
      dataStore.setSharedPortfolios(sharedPortfolios: state);
    }
  }

  void updateWithRemovedSharedArtifactId({
    required String sharedArtifactId,
    required String sharedPortfolioId,
  }) {
    state = state.withRemovedArtifactId(
      sharedArtifactId: sharedArtifactId,
      sharedPortfolioId: sharedPortfolioId,
    );
    dataStore.setSharedPortfolios(sharedPortfolios: state);
  }

  void reset() {
    state = SharedPortfolios([]);
    dataStore.clearSharedPortfolios();
  }
}

final sharedPortfoliosProvider = StateNotifierProvider<SharedPortfoliosManager, SharedPortfolios>((ref) {
  throw UnimplementedError();
});
