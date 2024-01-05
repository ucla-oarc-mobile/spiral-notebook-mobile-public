import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

import 'dart:io' show Platform;

import 'package:spiral_notebook/utilities/keyboard_visibility_builder.dart';

class ArtifactFloatingFooter extends StatefulWidget {
  const ArtifactFloatingFooter({
    Key? key,
    required this.maxWidth,
    required this.showLeftButton,
    required this.enableButtons,
    this.leftButtonText,
    required this.rightButtonText,
    this.onLeftTapUp,
    required this.onRightTapUp,
  }) : super(key: key);

  static double bottomGap = (Platform.isIOS) ? 30.0 : 0.0;

  final double maxWidth;

  final bool showLeftButton;
  final bool enableButtons;

  final String? leftButtonText;
  final String rightButtonText;

  final void Function()? onLeftTapUp;
  final void Function() onRightTapUp;

  @override
  State<ArtifactFloatingFooter> createState() => _ArtifactFloatingFooterState();
}

class _ArtifactFloatingFooterState extends State<ArtifactFloatingFooter> {

  bool activateDebounce = false;

  Timer? debounceTimer;

  void activateButton(void Function()? onActivate) {
    setState(() {
      activateDebounce = true;
    });

    // disable the button temporarily.
    debounceTimer = Timer(Duration(seconds: 1), () => setState(() => activateDebounce = false));

    if (widget.enableButtons)
      onActivate?.call();
  }

  @override
  void dispose() {
    debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showThisWidget = true;

    return Positioned(
        bottom: 0,
        child: KeyboardVisibilityBuilder(
          builder: (context, child, isKeyboardVisible) {
            showThisWidget = !isKeyboardVisible;

            return Opacity(
              opacity: showThisWidget ? 1 : 0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: widget.maxWidth,
                ),
                child: Container(
                  padding: EdgeInsets.only(bottom: ArtifactFloatingFooter.bottomGap),
                  color: Colors.white,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      widget.showLeftButton ? Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: activateDebounce || !showThisWidget ? () {} : () {activateButton(widget.onLeftTapUp);},
                          child: Semantics(
                            button: true,
                            enabled: true,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: widget.enableButtons ? primaryButtonBlue : buttonBorderGrey, width: 1.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('${widget.leftButtonText}'.toUpperCase(),
                                    style: TextStyle(color: widget.enableButtons ? primaryButtonBlue : buttonDisabledGrey, fontSize: 12.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ) : SizedBox(height: 1),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: activateDebounce ? () {} : () {activateButton(widget.onRightTapUp);},
                          child: Semantics(
                            button: true,
                            enabled: true,
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.enableButtons ? primaryButtonBlue : buttonBGDisabledGrey,
                                border: Border.all(color: widget.enableButtons ? primaryButtonBlue : buttonDisabledGrey, width: 1.0),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('${widget.rightButtonText}'.toUpperCase(),
                                    style: TextStyle(color: widget.enableButtons ? Colors.white : buttonDisabledGrey, fontSize: 12.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
    );
  }
}
