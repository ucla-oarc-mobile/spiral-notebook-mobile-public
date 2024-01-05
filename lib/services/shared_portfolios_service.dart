import 'package:spiral_notebook/api/eqis_api.dart';


class SharedPortfoliosService {
  final _portfolio = EqisAPI();

  Future<List<dynamic>>? fetchSharedPortfolios() async {
    final sharedPortfolios = await _portfolio.fetchSharedPortfolios();
    print(sharedPortfolios.runtimeType);
    return sharedPortfolios;
  }

}