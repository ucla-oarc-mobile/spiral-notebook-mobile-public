import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/models/shared_artifacts_comments/shared_artifacts_comment.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class SharedArtifactCommentItem extends ConsumerStatefulWidget {
  SharedArtifactCommentItem({
    required this.comment,
    required this.onTapEdit,
    required this.onTapDelete,
    required this.canModify,
    Key? key,
  }) : super(key: key);

  final SharedArtifactsComment comment;
  final Function() onTapEdit;
  final Function() onTapDelete;
  final bool canModify;

  @override
  _SharedArtifactCommentItemState createState() => _SharedArtifactCommentItemState();
}

class _SharedArtifactCommentItemState extends ConsumerState<SharedArtifactCommentItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.comment.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    widget.comment.formattedDateModified,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.comment.body),
            SizedBox(height: 12.0),
            if (widget.canModify)
              SizedBox(height: 30.0),
            Divider(thickness: 2.0, height: 2.0),
          ],
        ),
        if (widget.canModify)
          Positioned(
            bottom: 10.0,
            left: 10.0,
            child: GestureDetector(
              onTap: widget.onTapEdit,
              child: Semantics(
                link: true,
                child: Row(
                  children: [
                    Text('Edit', style: TextStyle(color: primaryButtonBlue)),
                    Icon(Icons.edit, color: primaryButtonBlue),
                  ],
                ),
              ),
            ),
          ),
        if (widget.canModify)
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: GestureDetector(
              onTap: widget.onTapDelete,
              child: Row(
                children: [
                  Text('Delete', style: TextStyle(color: primaryButtonBlue)),
                  Icon(Icons.delete, color: primaryButtonBlue),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
