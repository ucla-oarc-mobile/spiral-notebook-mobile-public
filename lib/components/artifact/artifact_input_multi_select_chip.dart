import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class ArtifactInputMultiSelectChip extends StatefulWidget {

  ArtifactInputMultiSelectChip(this.reportList, {required this.onSelectionChanged, this.initialSelections});
  // accepts prepopulated param for inserting selected choices.

  final List<String> reportList;
  final List<String>? initialSelections;
  final Function(List<String>) onSelectionChanged;


  @override
  _ArtifactInputMultiSelectChipState createState() => _ArtifactInputMultiSelectChipState();
}

class _ArtifactInputMultiSelectChipState extends State<ArtifactInputMultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];

    widget.reportList.forEach((item) {
      bool isSelected = selectedChoices.contains(item);
      choices.add(Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
        child: ChoiceChip(
          avatar: isSelected
              ? Icon(Icons.check, color: Colors.white)
              : Icon(Icons.add, color: primaryButtonBlue),
          label: Text(item, style: TextStyle(color: isSelected
              ? Colors.white
              : primaryButtonBlue),
          ),
          selected: isSelected,
          backgroundColor: Colors.white,
          selectedColor: primaryButtonBlue,
          onSelected: (selected) {
            setState(() {
              isSelected
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
          shape: StadiumBorder(
              side: BorderSide(
                width: 1,
                color: primaryButtonBlue,
              )),
        ),
      ));

    });
    return choices;
  }

  @override
  void initState() {
    selectedChoices =  widget.initialSelections ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
