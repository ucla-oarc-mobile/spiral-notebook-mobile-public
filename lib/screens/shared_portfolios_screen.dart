
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/common/inline_section_header.dart';
import 'package:spiral_notebook/components/common/universal_portfolios_picker.dart';
import 'package:spiral_notebook/components/common/universal_portfolio_item_metadata.dart';
import 'package:spiral_notebook/components/shared_portfolio/shared_portfolio_shared_artifacts_table.dart';
import 'package:spiral_notebook/models/shared_portfolio/shared_portfolio.dart';
import 'package:spiral_notebook/models/shared_portfolio/shared_portfolios.dart';
import 'package:spiral_notebook/providers/shared_portfolios_provider.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class SharedPortfoliosScreen extends ConsumerStatefulWidget {
  static String id = 'my_portfolios_screen';

  const SharedPortfoliosScreen({
    this.dashboardSelectedPortfolio,
  });

  final SharedPortfolio? dashboardSelectedPortfolio;

  @override
  _SharedPortfoliosScreenState createState() => _SharedPortfoliosScreenState();
}

class _SharedPortfoliosScreenState extends ConsumerState<SharedPortfoliosScreen> {

  String selectedPortfolioLabel = '';
  bool showDetails = false;

  SharedPortfolio? selectedPortfolio;

  @override
  void initState() {
    super.initState();

    selectedPortfolio = widget.dashboardSelectedPortfolio;
    showDetails = (selectedPortfolio != null);
  }

  @override
  Widget build(BuildContext context) {
    final SharedPortfolios sharedPortfolios = ref.watch(sharedPortfoliosProvider);
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
        title: Text('Shared Portfolios'.toUpperCase()),
        backgroundColor: primaryButtonBlue,
        actions: null,
      ),
      body: Center(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      InlineSectionHeader(label: 'Select Shared Portfolio'),
                      UniversalPortfoliosPicker(
                        defaultLabel: 'Select Shared Portfolio',
                        portfolioIds: sharedPortfolios.idsList,
                        portfolioNames: sharedPortfolios.namesList,
                        defaultPortfolioId: selectedPortfolio?.id,
                        onSelected: (String? chosenId) {
                          SharedPortfolio? chosenPortfolio;
                          (chosenId == null)
                              ? chosenPortfolio = null
                              : chosenPortfolio = sharedPortfolios.getById(chosenId);
                          setState(() {
                            selectedPortfolio = chosenPortfolio;
                            showDetails = (chosenId != null);
                            // render a new instance of the portfolio based on the chosen portfolio data.
                            showDetails ? selectedPortfolioLabel = chosenPortfolio!.name : selectedPortfolioLabel = 'Select Shared Portfolio';
                          });
                        },
                      ),
                      if (showDetails)
                        UniversalPortfolioItemMetadata(selectedPortfolio: selectedPortfolio!),
                      if (showDetails)
                        SharedPortfolioSharedArtifactsTable(selectedPortfolio: selectedPortfolio!),
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}

