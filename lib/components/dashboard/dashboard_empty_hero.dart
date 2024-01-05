import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/common/inline_section_header.dart';
import 'package:spiral_notebook/components/common/inline_section_text.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class DashboardEmptyHero extends StatelessWidget {
  const DashboardEmptyHero({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.arrow_downward, size: 65.0, color: primaryButtonBlue),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          child: InlineSectionHeader(label: 'Please pull to refresh'),
        ),
        InlineSectionText(label: '(Data not loaded)'),
      ],
    );
  }
}