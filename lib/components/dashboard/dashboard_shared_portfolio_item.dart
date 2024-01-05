import 'package:flutter/material.dart';
import 'package:spiral_notebook/models/shared_portfolio/shared_portfolio.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class DashboardSharedPortfolioItem extends StatelessWidget {
  const DashboardSharedPortfolioItem({
    required this.sharedPortfolio,
    required this.onSelected,
  });

  final SharedPortfolio sharedPortfolio;
  final ValueSetter<SharedPortfolio> onSelected;

  @override
  Widget build(BuildContext context) {
    final artifactsLength = sharedPortfolio.artifactIds.length;

    return GestureDetector(
      onTap: () {
        onSelected.call(sharedPortfolio);
      },
      // make sure the gesture covers its entire contents
      behavior: HitTestBehavior.translucent,
      child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sharedPortfolio.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('$artifactsLength '+ (artifactsLength == 1 ? 'Shared Artifact' : 'Shared Artifacts') ),
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_right, color: primaryButtonBlue),
                ],),
            ),
            Divider(thickness: 2.0,),
          ]
      ),
    );
  }
}
