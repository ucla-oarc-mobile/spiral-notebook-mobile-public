import 'package:flutter/cupertino.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class ArtifactInputSegmentedMediaTypeSelector extends StatelessWidget {
  ArtifactInputSegmentedMediaTypeSelector({
    Key? key,
    required this.options,
    required this.onValueChanged,
    required this.selectedMediaOption,
  }) : super(key: key);

  final Map<String, Widget> options;

  final ValueChanged<String> onValueChanged;
  final String? selectedMediaOption;


  @override
  Widget build(BuildContext context) {
    // kv map required by Widget
    // Map<String, Widget> children = Map.fromIterable(options, key: (e) => e.key, value: (e) => Text('${e.label}'));

    return CupertinoSegmentedControl(
      children: options,
      onValueChanged: onValueChanged,
      groupValue: selectedMediaOption,
      pressedColor: primaryButtonBlue,
      selectedColor: primaryButtonBlue,
    );
  }
}