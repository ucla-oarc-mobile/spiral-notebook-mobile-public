import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/models/portfolio/my_portfolios.dart';
import 'package:spiral_notebook/persistence/hive_data_store.dart';
import 'package:spiral_notebook/services/portfolios_service.dart';

class PortfoliosManager extends StateNotifier<MyPortfolios> {
  final HiveDataStore dataStore;

  PortfoliosManager({
    required MyPortfolios portfolios,
    required this.dataStore,
  }) : super(portfolios);

  void refreshWithJson(json) {
    state = MyPortfolios.fromJson(json);
    dataStore.setMyPortfolios(myPortfolios: state);
  }

  void updateWithArtifactJson(Map<String, dynamic> artifactJson) {
    state = state.withUpdatedSingleArtifactJson(artifactJson);
    dataStore.setMyPortfolios(myPortfolios: state);
  }

  void updateWithRemovedArtifactId({
    required String artifactId,
    required String portfolioId,
  }) {
    state = state.withRemovedArtifactId(
      artifactId: artifactId,
      portfolioId: portfolioId,
    );
    dataStore.setMyPortfolios(myPortfolios: state);
  }

  Future<dynamic> syncPortfolios() async {
    final PortfoliosService _portfolios = PortfoliosService();

    bool syncSuccess = false;

    final portfoliosResult = await _portfolios.fetchPortfolios();

    syncSuccess = (portfoliosResult != null);

    if (syncSuccess) {
      state = MyPortfolios.fromJson(portfoliosResult);
      dataStore.setMyPortfolios(myPortfolios: state);
    }
  }

  void reset() {
    state = MyPortfolios([]);
    dataStore.clearMyPortfolios();
  }
}

final myPortfoliosProvider = StateNotifierProvider<PortfoliosManager, MyPortfolios>((ref) {
  throw UnimplementedError();
});
