import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class DashboardAddArtifactButton extends StatelessWidget {
  const DashboardAddArtifactButton({
    Key? key,
    required this.buttonHandler,
    required this.buttonLabelImagePath,
    required this.buttonLabelText,
  }) : super(key: key);

  final String buttonLabelImagePath;
  final String buttonLabelText;
  final void Function() buttonHandler;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ElevatedButton(
        onPressed: buttonHandler,
        style: ElevatedButton.styleFrom(
            elevation: 0.0, backgroundColor: Colors.white,
            side: BorderSide(width: 1.0, color: primaryButtonBlue),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0),
            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 30.0,
                  child: Image.asset(buttonLabelImagePath),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(buttonLabelText, style: TextStyle(color: primaryButtonBlue, fontSize: 12.0 )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}