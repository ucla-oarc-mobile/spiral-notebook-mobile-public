import 'package:flutter/material.dart';
import 'package:spiral_notebook/models/portfolio/portfolio.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class DashboardPortfolioItem extends StatelessWidget {
  const DashboardPortfolioItem({
    required this.portfolio,
    required this.onSelected,
  });

  final Portfolio portfolio;
  final ValueSetter<Portfolio> onSelected;

  @override
  Widget build(BuildContext context) {
    final artifactsLength = portfolio.artifactIds.length;

    return GestureDetector(
      onTap: () {
        onSelected.call(portfolio);
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
                      Text(portfolio.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('$artifactsLength '+ (artifactsLength == 1 ? 'Artifact' : 'Artifacts') ),
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
