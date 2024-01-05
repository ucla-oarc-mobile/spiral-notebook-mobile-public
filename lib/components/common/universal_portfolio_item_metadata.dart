import 'package:flutter/material.dart';
import 'package:spiral_notebook/models/portfolio/portfolio.dart';
import 'package:spiral_notebook/models/shared_portfolio/shared_portfolio.dart';

class UniversalPortfolioItemMetadata extends StatelessWidget {
  const UniversalPortfolioItemMetadata({
    Key? key,
    required this.selectedPortfolio,
  }) : super(key: key);

  // This can be either a Portfolio or a SharedPortfolio.
  final dynamic selectedPortfolio;

  @override
  Widget build(BuildContext context) {

    String gradeLevels = 'No Grade Levels';

    try {
      // type conversion to List<String> is necessary before the reduce
      // operation since it returns a string.
      gradeLevels =
          List<String>.from(selectedPortfolio.grades).reduce((value, element) => value + ", " +element);
    } catch (e) {
      print('grade levels are empty!');
    }

    RichText metadataRow({required String label, required String body}) {
      return RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(text: '$label: ' , style: TextStyle(fontWeight: FontWeight.bold)),
            (body.isNotEmpty && body != 'null')
              ? TextSpan(text: '$body', style: TextStyle(fontWeight: FontWeight.normal))
                : TextSpan(text: '(None provided)', style: TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Color.fromARGB(255, 238, 238, 238),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Summary: ${selectedPortfolio.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                SizedBox(height: 12.0),
                metadataRow(label: 'Grade Levels', body: '$gradeLevels'),
                // since selectedPortfolio is dynamic (no type checking),
                // verify object type before attempting to render
                if (selectedPortfolio is Portfolio || selectedPortfolio is SharedPortfolio)
                  metadataRow(label: 'Subject', body: '${selectedPortfolio.subject}'),
                if (selectedPortfolio is Portfolio || selectedPortfolio is SharedPortfolio)
                  metadataRow(label: 'Portfolio Topic', body: '${selectedPortfolio.topic}'),
                // NOTE: PLC Goals have been requested to not display in the views.
                // if (selectedPortfolio is SharedPortfolio)
                //   metadataRow(label: 'PLC Goals', body: '${selectedPortfolio.plcGoals}'),
                if (selectedPortfolio is SharedPortfolio)
                  metadataRow(label: 'PLC Name', body: '${selectedPortfolio.plcName}'),
                if (selectedPortfolio is Portfolio || selectedPortfolio is SharedPortfolio)
                  metadataRow(label: 'Date Created', body: '${selectedPortfolio.formattedDateCreated}'),
                if (selectedPortfolio is Portfolio || selectedPortfolio is SharedPortfolio)
                  metadataRow(label: 'Total Artifacts', body: '${selectedPortfolio.artifactIds.length}'),
              ],
            ),
          ),
        ),
        Divider(thickness: 2.0, height: 2.0),
      ],
    );
  }
}