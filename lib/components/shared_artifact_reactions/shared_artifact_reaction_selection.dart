import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class SharedArtifactReactionSelection extends StatefulWidget {
  const SharedArtifactReactionSelection({
    Key? key,
    required this.label,
    required this.totalCount,
    required this.isEnabled,
    required this.onTap,
  }) : super(key: key);


  final String label;
  final int totalCount;
  final bool isEnabled;
  final Function() onTap;
  @override
  _SharedArtifactReactionSelectionState createState() => _SharedArtifactReactionSelectionState();
}

class _SharedArtifactReactionSelectionState extends State<SharedArtifactReactionSelection> {

  late bool isSelected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = widget.isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    String displayCount = (widget.totalCount == 0) ? '+' : '${widget.totalCount}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
      child: ChoiceChip(
        avatar: Text(widget.label, style: TextStyle(fontSize: 22.0),),
        label: Container(
          width: 34.0,
          height: 33.0,
          child: Center(
            child: Text(displayCount,
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: isSelected
                  ? Colors.white
                  : primaryButtonBlue, fontSize: 18.0),
            ),
          ),
        ),
        labelPadding:  const EdgeInsets.only(right: 5.0),
        selected: isSelected,
        backgroundColor: Colors.white,
        selectedColor: primaryButtonBlue,
        onSelected: (selected) {
            widget.onTap.call();
            setState(() {
              isSelected = !isSelected;
            });
        },
        shape: StadiumBorder(
            side: BorderSide(
              width: 1,
              color: primaryButtonBlue,
            )),
      ),
    );
  }
}
