import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/common/inline_section_header.dart';
import 'package:spiral_notebook/components/common/universal_portfolios_picker.dart';
import 'package:spiral_notebook/components/dashboard/dashboard_add_artifact_button.dart';
import 'package:spiral_notebook/components/dashboard/dashboard_empty_hero.dart';
import 'package:spiral_notebook/components/dashboard/dashboard_last_synced.dart';
import 'package:spiral_notebook/components/dashboard/dashboard_portfolio_item.dart';
import 'package:spiral_notebook/components/dashboard/dashboard_parking_lot_section.dart';
import 'package:spiral_notebook/components/dashboard/dashboard_shared_portfolio_item.dart';
import 'package:spiral_notebook/components/rounded_button.dart';
import 'package:spiral_notebook/models/portfolio/my_portfolios.dart';
import 'package:spiral_notebook/models/portfolio/portfolio.dart';
import 'package:spiral_notebook/models/shared_portfolio/shared_portfolios.dart';
import 'package:spiral_notebook/providers/artifact_operations_provider.dart';
import 'package:spiral_notebook/providers/multi_providers_manager.dart';
import 'package:spiral_notebook/providers/my_portfolios_provider.dart';
import 'package:spiral_notebook/providers/shared_portfolios_provider.dart';
import 'package:spiral_notebook/screens/add_artifact_screen.dart';
import 'package:spiral_notebook/screens/my_portfolios_screen.dart';
import 'package:spiral_notebook/screens/shared_portfolios_screen.dart';
import 'package:spiral_notebook/services/answers_service.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/utilities/loading.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';

// This provider tracks the selected portfolio. It derives from selected portfolio
// ID, but it also derives from myPortfoliosProvider to verify that the selection
// is valid.
final dashboardSelectedPortfolioProvider = Provider<Portfolio?>((ref) {
  final String? portfolioId = ref.watch(dashboardSelectedPortfolioIdProvider);

  if (portfolioId == null) return null;

  final MyPortfolios portfolios = ref.watch(myPortfoliosProvider);
  final int indexFound = portfolios.portfolios.indexWhere((portfolio) => portfolio.id == portfolioId);
  if (indexFound == -1) {
    // this is a "coupling" between My Portfolios and the selected Portfolio ID.
    // If My Portfolios have changed so that the ID is not in the collection,
    // we clear out the "selection."
    return null;
  }

  return portfolios.portfolios[indexFound];
});

// This provider does not update itself based on My Portfolios. It is used
// to track the user's Portfolio ID selection.
final dashboardSelectedPortfolioIdProvider = StateProvider<String?>((ref) => null);

class DashboardScreen extends ConsumerStatefulWidget {

  const DashboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final AnswersService _answers = AnswersService();

  String? selectedPortfolioId;
  Portfolio? selectedPortfolio;

  @override
  void initState() {
    super.initState();
  }

  void addMediaButton()  {
    addFileButton(ModifyArtifactFileType.media);
  }

  void addDocumentButton() async {
    addFileButton(ModifyArtifactFileType.document);
  }

  void addFileButton(ModifyArtifactFileType fileType) async {

    // Uses the selected Portfolio provider (not ID provider), which syncs itself
    // with myPortfolios to ensure only valid IDs are used.
    String? mySelectedPortfolioId = selectedPortfolio?.id ?? null;

    if (mySelectedPortfolioId == null) {
      showSnackAlert(context, 'Please select a portfolio.');
      return;
    }


    // get a new artifact ID from the server - async.
    String newArtifactId = '';

    try {
      showLoading(context, 'Initializing New Artifact...');
      newArtifactId = await _answers.getNewArtifactId(
        portfolioId: mySelectedPortfolioId,
      );

      print('$newArtifactId');

      dismissLoading(context);

      // Set our current artifact operation mode to "Edit"
      // so our Question components access the appropriate Response Provider.
      // debug note: it seems that a basic StateProvider's state can only be
      // modified in a ref.read that is executed inside of a widget callback.
      // It *cannot* be modified inside of a widget life cycle method
      // such as `initState` or `build`.
      ref.read(artifactOperationModeProvider.notifier).state = ArtifactOperationMode.add;
      ref.read(artifactOperationTypeProvider.notifier).state = ArtifactOperationType.artifact;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddArtifactScreen(
        portfolioId: mySelectedPortfolioId,
        artifactId: newArtifactId,
        fileType: fileType,
      )));

    } catch (e) {
      Navigator.pop(context);
      String message = (e is HttpException)
          ? e.message
          : "Error launching artifact, please try again.";
      showSnackAlert(context, message);
    }
  }


  @override
  Widget build(BuildContext context) {
    final MyPortfolios myPortfolios = ref.watch(myPortfoliosProvider);
    final SharedPortfolios sharedPortfolios = ref.watch(sharedPortfoliosProvider);
    selectedPortfolio = ref.watch(dashboardSelectedPortfolioProvider);
    selectedPortfolioId = ref.watch(dashboardSelectedPortfolioIdProvider);

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return RefreshIndicator(
            onRefresh: () async {
              try {
                final MultiProviderManager multiProviderManager = MultiProviderManager(ref);

                await multiProviderManager.refreshAll();
              } catch (e) {
                String message = (e is HttpException)
                    ? e.message
                    : "Error refreshing page, please try again.";
                showSnackAlert(context, message);
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child:
                myPortfolios.portfolios.isEmpty
                    ? DashboardEmptyHero()
                    : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      DashboardLastSynced(),
                      InlineSectionHeader(label: 'Add Artifact'),
                      UniversalPortfoliosPicker(
                        defaultLabel: 'Select Portfolio',
                        portfolioIds: myPortfolios.idsList,
                        portfolioNames: myPortfolios.namesList,
                        defaultPortfolioId: selectedPortfolio?.id ?? null,
                        onSelected: (String? chosenId) {
                          ref.read(dashboardSelectedPortfolioIdProvider.notifier).state = chosenId;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: DashboardAddArtifactButton(
                                buttonHandler: addMediaButton,
                                buttonLabelImagePath: 'images/icon/icon-add-photo-video.png',
                                buttonLabelText: 'Add Photo/Video',
                              ),
                            ),
                            Expanded(
                              child: DashboardAddArtifactButton(
                                buttonHandler: addDocumentButton,
                                buttonLabelImagePath: 'images/icon/icon-add-file.png',
                                buttonLabelText: 'Add File',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0,),
                      DashboardParkingLotSection(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Divider(thickness: 2.0,),
                      ),
                      InlineSectionHeader(label: 'My Portfolios'),
                      Divider(thickness: 2.0,),
                      Column(children: myPortfolios.portfolios.map((portfolio) => DashboardPortfolioItem(
                        portfolio: portfolio,
                        onSelected: (portfolio) {
                          //navigate to the portfolio view with selectedPortfolio engaged.
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyPortfoliosScreen(
                            dashboardSelectedPortfolio: portfolio,
                          )));
                        },
                      )).toList()),
                      SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100.0,vertical: 0.0),
                        child: RoundedButton(
                          myColor: primaryButtonBlue,
                          myText: 'View My Portfolios',
                          myOnPressed: ()  {

                            // Navigator.pushNamed(context, MyPortfoliosScreen.id);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyPortfoliosScreen(
                              // NO portfolio is selected
                              dashboardSelectedPortfolio: null,
                            )));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Divider(thickness: 2.0,),
                      ),
                      SizedBox(height: 8.0,),
                      InlineSectionHeader(label: 'Shared Portfolios'),
                      Divider(thickness: 2.0,),
                      Column(children: sharedPortfolios.portfolios.map((sharedPortfolio) => DashboardSharedPortfolioItem(
                        sharedPortfolio: sharedPortfolio,
                        onSelected: (portfolio) {
                          //navigate to the portfolio view with selectedPortfolio engaged.
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SharedPortfoliosScreen(
                            dashboardSelectedPortfolio: portfolio,
                          )));
                        },
                      )).toList()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100.0,vertical: 0.0),
                        child: RoundedButton(
                          myColor: primaryButtonBlue,
                          myText: 'View Shared Portfolios',
                          myOnPressed: ()  {

                            // Navigator.pushNamed(context, MyPortfoliosScreen.id);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SharedPortfoliosScreen(
                              // NO portfolio is selected
                              dashboardSelectedPortfolio: null,
                            )));
                          },
                        ),
                      ),
                      SizedBox(height: 40.0),
                    ]
                ),
              ),
            ),
          );
        }
    );
  }
}


