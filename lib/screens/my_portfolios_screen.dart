import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/common/inline_section_header.dart';
import 'package:spiral_notebook/components/common/universal_portfolios_picker.dart';
import 'package:spiral_notebook/components/myportfolio/myportfolio_artifacts_table.dart';
import 'package:spiral_notebook/components/common/universal_portfolio_item_metadata.dart';
import 'package:spiral_notebook/models/portfolio/my_portfolios.dart';
import 'package:spiral_notebook/models/portfolio/portfolio.dart';
import 'package:spiral_notebook/providers/my_portfolios_provider.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class MyPortfoliosScreen extends ConsumerStatefulWidget {
  static String id = 'my_portfolios_screen';

  const MyPortfoliosScreen({
    this.dashboardSelectedPortfolio,
  });

  final Portfolio? dashboardSelectedPortfolio;

  @override
  _MyPortfoliosScreenState createState() => _MyPortfoliosScreenState();
}

class _MyPortfoliosScreenState extends ConsumerState<MyPortfoliosScreen> {

  String selectedPortfolioLabel = '';
  bool showDetails = false;

  Portfolio? selectedPortfolio;

  @override
  void initState() {
    super.initState();

    selectedPortfolio = widget.dashboardSelectedPortfolio;
    showDetails = (selectedPortfolio != null);
  }

  @override
  Widget build(BuildContext context) {
    final MyPortfolios myPortfolios = ref.watch(myPortfoliosProvider);
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
        title: Text('My Portfolios'.toUpperCase()),
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
                      InlineSectionHeader(label: 'Select Individual Portfolio'),
                      UniversalPortfoliosPicker(
                        defaultLabel: 'Select Portfolio',
                        portfolioIds: myPortfolios.idsList,
                        portfolioNames: myPortfolios.namesList,
                        defaultPortfolioId: selectedPortfolio?.id,
                        onSelected: (String? chosenId) {
                          Portfolio? chosenPortfolio;
                          (chosenId == null)
                              ? chosenPortfolio = null
                              : chosenPortfolio = myPortfolios.getById(chosenId);
                          setState(() {
                            selectedPortfolio = chosenPortfolio;
                            showDetails = (chosenPortfolio != null);
                            // render a new instance of the portfolio based on the chosen portfolio data.
                            showDetails ? selectedPortfolioLabel = chosenPortfolio!.name : selectedPortfolioLabel = 'Select Portfolio';
                          });
                        },
                      ),
                      if (showDetails)
                        UniversalPortfolioItemMetadata(selectedPortfolio: selectedPortfolio!),
                      if (showDetails)
                        MyPortfolioArtifactsTable(selectedPortfolio: selectedPortfolio!),
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

