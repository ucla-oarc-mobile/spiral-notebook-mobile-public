import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class AppBarProgressBar extends StatelessWidget {
  const AppBarProgressBar({
    Key? key, required this.progress,
  }) : super(key: key);

  final double progress;

  static const _barHeight = 20.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: viewportConstraints.maxWidth * 0.8,
            ),
            child: FractionallySizedBox(
              widthFactor: 1.0,
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: interfaceButtonBlue,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.white, width: 1.0),
                      ),
                      child: SizedBox(
                        height: _barHeight,
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(color: Colors.white, width: 1.0),
                      ),
                      child: SizedBox(
                        height: _barHeight,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        }
    );
  }
}
