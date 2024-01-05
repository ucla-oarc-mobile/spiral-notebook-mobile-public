import 'package:flutter/cupertino.dart';
import 'package:spiral_notebook/models/questions/question_choice_single_option.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class ArtifactInputSegmentedSingleSelector extends StatefulWidget {
  ArtifactInputSegmentedSingleSelector({
    Key? key,
    required this.options,
    required this.onValueChanged,
    required this.selectedValue,
  }) : super(key: key);

  final List<QuestionChoiceSingleOption> options;

  final ValueChanged<String> onValueChanged;
  final String? selectedValue;

  @override
  State<ArtifactInputSegmentedSingleSelector> createState() => _ArtifactInputSegmentedSingleSelectorState();
}

class _ArtifactInputSegmentedSingleSelectorState extends State<ArtifactInputSegmentedSingleSelector> {
  @override
  Widget build(BuildContext context) {
    // Converts the simple flat list of artifact options into the kv map required by Widget
    Map<String, Widget> children = Map.fromIterable(widget.options, key: (e) => e.key, value: (e) => Text('${e.label}'));

    return CupertinoSegmentedControl(
      children: children,
      onValueChanged: widget.onValueChanged,
      groupValue: widget.selectedValue,
      pressedColor: primaryButtonBlue,
      selectedColor: primaryButtonBlue,
      // unselectedColor: buttonDisabledGrey,
    );
  }
}