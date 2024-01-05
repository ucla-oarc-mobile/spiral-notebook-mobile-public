import 'package:hive/hive.dart';
import 'package:spiral_notebook/models/shared_portfolio/shared_portfolio.dart';

part 'shared_portfolios.g.dart';


@HiveType(typeId: 5)
class SharedPortfolios {

  @HiveField(0)
  List<SharedPortfolio> portfolios;

  SharedPortfolios(this.portfolios);

  List<String> get namesList => portfolios.map((portfolio) => portfolio.name).toList();
  List<String> get idsList => portfolios.map((portfolio) => portfolio.id).toList();

  SharedPortfolio getById(String id) => portfolios.firstWhere(
        (portfolio) => portfolio.id == id,
    orElse: () => throw Exception('invalid Portfolio ID $id'),
  );

  static List<SharedPortfolio> listFromSharedPortfolios(List<dynamic> portfolios) {
    List<SharedPortfolio> portfoliosList = [];

    portfolios.forEach((portfolio) {

      portfoliosList.add(SharedPortfolio.fromJson(
          parsedJson: portfolio));
    });

    // ensure that all portfolios are sorted by date created. Critical!
    portfoliosList
        .sort((a, b) => (a.dateCreated.compareTo(b.dateCreated)));
    return portfoliosList;
  }

  SharedPortfolios.fromJson(List<dynamic> parsedJson)
      : portfolios = listFromSharedPortfolios(parsedJson);

  SharedPortfolios withUpdatedSingleArtifactJson(Map<String, dynamic> sharedArtifactJson) {
    // it's possible that a new shared artifact has been added.
    // update the corresponding portfolio with the new shared artifact data.
    // in this case, it's the list of matching sharedArtifactIds.
    final String portfolioId = (sharedArtifactJson['sharedPortfolio'].runtimeType == int)
        ? '${sharedArtifactJson['sharedPortfolio']}'
        : '${sharedArtifactJson['sharedPortfolio']['id']}';
    final String artifactId = '${sharedArtifactJson['id']}';

    int indexToUpdate = portfolios.indexWhere((portfolio) => portfolio.id == portfolioId);

    if (indexToUpdate != -1)
      portfolios[indexToUpdate].mergeNewArtifactId(artifactId);

    return SharedPortfolios(this.portfolios);
  }

  SharedPortfolios withRemovedArtifactId({
    required String sharedArtifactId,
    required String sharedPortfolioId,
  }) {

    int indexToUpdate = portfolios.indexWhere((portfolio) => portfolio.id == sharedPortfolioId);

    if (indexToUpdate != -1) {
      SharedPortfolio newSharedPortfolio = SharedPortfolio.fromRemovedArtifactId(
        oldPortfolio: portfolios[indexToUpdate],
        artifactId: sharedArtifactId,
      );
      portfolios[indexToUpdate] = newSharedPortfolio;
    }

    return SharedPortfolios(this.portfolios);
  }
  // interfaces with the sharedPortfoliosProvider,
  // defined in `providers/shared_portfolios_provider`
}