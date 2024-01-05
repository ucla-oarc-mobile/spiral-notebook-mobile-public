import 'package:hive/hive.dart';
import 'package:spiral_notebook/models/portfolio/portfolio.dart';

part 'my_portfolios.g.dart';

@HiveType(typeId: 1)
class MyPortfolios {

  @HiveField(0)
  List<Portfolio> portfolios;

  MyPortfolios(this.portfolios);

  List<String> get namesList => portfolios.map((portfolio) => portfolio.name).toList();
  List<String> get idsList => portfolios.map((portfolio) => portfolio.id).toList();

  Portfolio getById(id) => portfolios.firstWhere(
      (portfolio) => portfolio.id == id,
      orElse: () => throw Exception('invalid Portfolio ID $id'),
  );


  static List<Portfolio> listFromPortfolios(List<dynamic> portfolios) {
    List<Portfolio> portfoliosList = [];

    portfolios.forEach((portfolio) {

      portfoliosList.add(Portfolio.fromJson(
          parsedJson: portfolio));
    });

    // ensure that all portfolios are sorted by date created. Critical!
    portfoliosList
        .sort((a, b) => (a.dateCreated.compareTo(b.dateCreated)));
    return portfoliosList;
  }
  MyPortfolios.fromJson(List<dynamic> parsedJson)
    : portfolios = listFromPortfolios(parsedJson);

  MyPortfolios withUpdatedSingleArtifactJson(Map<String, dynamic> artifactJson) {
    // it's possible that a new artifact has been added.
    // update the corresponding portfolio with the new artifact data.
    // in this case, it's the list of matching artifactIds.
    final String portfolioId = (artifactJson['portfolio'].runtimeType == int)
        ? '${artifactJson['portfolio']}'
        : '${artifactJson['portfolio']['id']}';
    final String artifactId = '${artifactJson['id']}';

    int indexToUpdate = portfolios.indexWhere((portfolio) => portfolio.id == portfolioId);

    if (indexToUpdate != -1)
      portfolios[indexToUpdate].mergeNewArtifactId(artifactId);

    return MyPortfolios(this.portfolios);
  }

  MyPortfolios withRemovedArtifactId({
    required String artifactId,
    required String portfolioId,
  }) {

    int indexToUpdate = portfolios.indexWhere((portfolio) => portfolio.id == portfolioId);

    if (indexToUpdate != -1) {
      Portfolio newPortfolio = Portfolio.fromRemovedArtifactId(
        oldPortfolio: portfolios[indexToUpdate],
        artifactId: artifactId,
      );
      portfolios[indexToUpdate] = newPortfolio;
    }

    return MyPortfolios(this.portfolios);
  }

}

