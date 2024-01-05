import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class ArtifactInputNumberIncrement extends StatefulWidget {
  const ArtifactInputNumberIncrement({
    Key? key, required this.onValueChanged, required this.initialValue,
  }) : super(key: key);

  final ValueChanged<String> onValueChanged;

  final String initialValue;

  @override
  _ArtifactInputNumberIncrementState createState() => _ArtifactInputNumberIncrementState();
}

class _ArtifactInputNumberIncrementState extends State<ArtifactInputNumberIncrement> {

  TextEditingController _txtController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _txtController.text = widget.initialValue;

  }

  @override
  Widget build(BuildContext context) {


    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 175,
          child: TextField(

            controller: _txtController,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.none,
            autocorrect: false,
            enableSuggestions: false,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.0),
            onChanged: widget.onValueChanged,
            decoration: kTextFieldDecoration.copyWith(
              hintText: '',
              contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
              prefixIcon: GestureDetector(
                onTap: () {
                  int? result = int.tryParse(_txtController.text);
                  if (result == null) {
                    _txtController.text = '0';
                  } else {
                    String _newValue = (--result).toString();
                    _txtController.value = TextEditingValue(
                      text: _newValue,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: _newValue.length),
                      ),
                    );
                  }
                  widget.onValueChanged(_txtController.text);
                },
                child: Semantics(
                  button: true,
                  enabled: true,
                  label: 'Decrement',
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryButtonBlue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  int? result = int.tryParse(_txtController.text);
                  if (result == null) {
                    _txtController.text = '0';
                  } else {
                    String _newValue = (++result).toString();
                    _txtController.value = TextEditingValue(
                      text: _newValue,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: _newValue.length),
                      ),
                    );
                  }
                  widget.onValueChanged(_txtController.text);
                },
                child: Semantics(
                  button: true,
                  enabled: true,
                  label: 'Increment',
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryButtonBlue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}