import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class UniversalPortfoliosPicker extends StatefulWidget {
  const UniversalPortfoliosPicker({
    Key? key,
    required this.defaultLabel,
    required this.portfolioNames,
    required this.portfolioIds,
    required this.onSelected,
    this.defaultPortfolioId,
  }) : super(key: key);

  final String defaultLabel;
  final ValueSetter<String?> onSelected;
  final List<String> portfolioIds;
  final List<String> portfolioNames;
  final String? defaultPortfolioId;

  @override
  _UniversalPortfoliosPickerState createState() => _UniversalPortfoliosPickerState();
}

class _UniversalPortfoliosPickerState extends State<UniversalPortfoliosPicker> {
  String pickerLabel = '';
  int selectedIndex = 0;
  bool pickerExpanded = false;

  late List<String> myPortfolioNames;
  late List<String> myPortfolioIds;

  @override
  void initState() {
    int portfolioIndex = widget.portfolioIds.indexWhere((id) => id == widget.defaultPortfolioId);

    // indexWhere returns -1 if item is not found
    // so we can just add +1 to the result.
    selectedIndex = 1 + portfolioIndex;

    (portfolioIndex == -1)
        ? pickerLabel = widget.defaultLabel
        : pickerLabel = widget.portfolioNames[portfolioIndex];

    myPortfolioNames = [widget.defaultLabel, ...widget.portfolioNames];
    myPortfolioIds = ['', ...widget.portfolioIds];

    super.initState();
  }

  void _showPicker(TapDownDetails details) async {
    setState(() {
      pickerExpanded = true;
    });
      await showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          // width: 300,
          height: 250,
            child: Stack(
              children: [
                CupertinoPicker(
                    backgroundColor: Colors.white,
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(initialItem: selectedIndex),
                    children: myPortfolioNames.map((e) => Center(child: Text(e))).toList(),
                    onSelectedItemChanged: (value) {
                      setState(() {
                        selectedIndex = value;
                        pickerLabel = myPortfolioNames[selectedIndex];
                      });
                    }
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (details) {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text('Done', style: Theme.of(context).textTheme.labelLarge?.merge(
                          TextStyle(
                            color: interfaceButtonBlue,
                            fontSize: 18.0,
                          ))),
                    ),
                  ),
                ),
              ],
            )
        ),
    );
    setState(() {
      String? chosenId;
      selectedIndex == 0
          ? chosenId = null
          : chosenId = myPortfolioIds[selectedIndex];

      widget.onSelected.call(chosenId);
      pickerExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    myPortfolioNames = [widget.defaultLabel, ...widget.portfolioNames];
    myPortfolioIds = ['', ...widget.portfolioIds];

    if (selectedIndex >= myPortfolioNames.length || pickerLabel != myPortfolioNames[selectedIndex]) {
      // if our selected index is out of range,
      // or the label doesn't match the corresponding name,
      // reset the picker to default.

      pickerLabel = widget.defaultLabel;
      selectedIndex = 0;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Divider(thickness: 2.0, height: 2.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget>[
                Text(pickerLabel),
                Icon(pickerExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: primaryButtonBlue,),
              ],),
          ),
          Divider(thickness: 2.0, height: 2.0),
        ],
      ),
      onTapDown: _showPicker,
    );
  }
}
