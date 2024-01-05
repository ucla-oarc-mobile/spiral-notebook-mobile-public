import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class ArtifactInputSingleText extends StatefulWidget {
  const ArtifactInputSingleText({
    Key? key,
    required this.hintText,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  final String hintText;

  final ValueSetter<String>? onChanged;

  final String? initialValue;

  @override
  State<ArtifactInputSingleText> createState() => _ArtifactInputSingleTextState();
}

class _ArtifactInputSingleTextState extends State<ArtifactInputSingleText> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      autocorrect: true,
      enableSuggestions: true,
      textAlign: TextAlign.left,
      onChanged: widget.onChanged,
      decoration: kTextFieldDecoration.copyWith(
        hintText: widget.hintText,
      ),
    );
  }
}