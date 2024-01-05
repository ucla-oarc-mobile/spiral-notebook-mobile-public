import 'package:spiral_notebook/api/eqis_api.dart';


class PortfoliosService {
  final _portfolio = EqisAPI();

  Future<List<dynamic>>? fetchPortfolios() async {
    final portfolios = await _portfolio.fetchPortfolios();
    print(portfolios.runtimeType);
    return portfolios;
  }

}