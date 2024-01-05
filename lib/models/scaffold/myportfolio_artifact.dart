import 'package:intl/intl.dart';

class ScaffoldMyPortfolioArtifact {
  late String name;
  bool inParkingLot = false;
  late DateTime dateCreated;

  ScaffoldMyPortfolioArtifact(this.name, this.inParkingLot, this.dateCreated);

  List<String> _names = [
    'Assessment',
    'Instruction',
    'Initial Reflection',
    'Reflection',
  ];

  List<int> _shuffle = [0,1,2];

  String get formattedDate {
    var formatter = new DateFormat('MM-dd-yy');
    String date = formatter.format(dateCreated);
    return date;
  }

  ScaffoldMyPortfolioArtifact.boilerplate(this.name) {
    name = (_names.toList()..shuffle()).first;
    inParkingLot =  (_shuffle.toList()..shuffle()).first == 0;
    var now = new DateTime.now();
    dateCreated = now.subtract(new Duration(days: (_shuffle.toList()..shuffle()).first));
  }
}