import 'dart:math';

import 'package:spiral_notebook/models/scaffold/myportfolio_artifact.dart';

class ScaffoldMyPortfolioArtifacts {
  List<ScaffoldMyPortfolioArtifact> list = [];

  ScaffoldMyPortfolioArtifacts.boilerplate(this.list) {
    final _random = new Random();
    int _numArtifacts = 2 + _random.nextInt(17);

    for (var i = 0; i < _numArtifacts; i++) {
      list.add(ScaffoldMyPortfolioArtifact.boilerplate(''));
    }
    print('artifacts: ${list.length}');
  }
}