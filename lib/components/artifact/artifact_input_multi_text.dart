import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class ArtifactInputMultiText extends StatefulWidget {
  const ArtifactInputMultiText({
    Key? key,
    required this.hintText,
    this.onChanged,
    this.initialValue,
  }) : super(key: key);

  final String hintText;

  final ValueSetter<String>? onChanged;

  final String? initialValue;

  @override
  State<ArtifactInputMultiText> createState() => _ArtifactInputMultiTextState();
}

class _ArtifactInputMultiTextState extends State<ArtifactInputMultiText> {
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
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      autocorrect: true,
      enableSuggestions: true,
      minLines: 10,
      maxLines: 10,
      textAlign: TextAlign.left,
      onChanged: widget.onChanged,
      decoration: kTextFieldDecoration.copyWith(
        hintText: widget.hintText,
      ),
    );
  }
}