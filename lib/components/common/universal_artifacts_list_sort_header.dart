import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/providers/universal_artifacts_list_sorted_provider.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class UniversalArtifactsListSortHeader extends ConsumerWidget {
  const UniversalArtifactsListSortHeader({
    Key? key,
    required this.label,
    required this.iconToggleFlipCondition,
    required this.isSharedArtifact,
    required this.colorCriteria,
    required this.padding,
    required this.sortToggleCallback,
  }) : super(key: key);

  final String label;
  final bool iconToggleFlipCondition;
  final bool isSharedArtifact;
  final UniversalArtifactsListSortCriteria colorCriteria;
  final EdgeInsetsGeometry padding;
  final VoidCallback sortToggleCallback;

  Color getColorByCriteria(UniversalArtifactsListSortCriteria activeSortCriteria, UniversalArtifactsListSortCriteria myCriteria) =>
      (activeSortCriteria == myCriteria)
          ? primaryButtonBlue : Colors.black;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UniversalArtifactsListSortCriteria currentSortCriteria = (isSharedArtifact)
     ? ref.read(sharedArtifactsListSortCriteriaProvider)
     : ref.read(artifactsListSortCriteriaProvider);

    return Flexible(
      child: GestureDetector(
        onTap: sortToggleCallback,
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Padding(
            padding: padding,
            child: Row(
              children: [
                Text(label.toUpperCase(), style: artifactsListHeaderStyle.copyWith(
                  color: getColorByCriteria(currentSortCriteria, colorCriteria),
                )),
                Icon(iconToggleFlipCondition
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                  color: getColorByCriteria(currentSortCriteria, colorCriteria),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
