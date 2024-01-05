import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/artifact/artifact_data_header.dart';
import 'package:spiral_notebook/components/artifact_details/artifact_details_files_preview.dart';
import 'package:spiral_notebook/components/artifact_details/artifact_details_inline_notice.dart';
import 'package:spiral_notebook/components/artifact_details/artifact_details_response_choices_list.dart';
import 'package:spiral_notebook/components/artifact_details/artifact_details_response_choices_tags.dart';
import 'package:spiral_notebook/components/artifact_details/artifact_details_response_text.dart';
import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/models/response/file_responses_remote.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class ArtifactDetailsBuilder extends ConsumerStatefulWidget {
  ArtifactDetailsBuilder({
    required this.question,
    required this.onTapEdit,
    required this.fileResponses,
    required this.textResponse,
    Key? key,
  }) : super(key: key);

  final Question question;
  final Function() onTapEdit;

  final FileResponsesRemote fileResponses;
  final dynamic textResponse;

  @override
  _ArtifactDetailsBuilderState createState() => _ArtifactDetailsBuilderState();
}

class _ArtifactDetailsBuilderState extends ConsumerState<ArtifactDetailsBuilder> {

  late String dataHeader;



  Widget getWidget() {

    Widget? myGroup;
    switch (widget.question.type) {
      case QuestionType.files:
        myGroup = ArtifactDetailsFilesPreview(fileResponses: widget.fileResponses);
        break;
      case QuestionType.number:
        myGroup = ArtifactDetailsResponseText(text: '${widget.textResponse}');
        break;
      case QuestionType.longText:
      case QuestionType.shortText:
      case QuestionType.singleChoice:
        myGroup = ArtifactDetailsResponseText(text: widget.textResponse as String);
        break;
      case QuestionType.multiChoice:
        myGroup =ArtifactDetailsTagChoices(tags: widget.textResponse as List<String>);
        break;
      case QuestionType.expansionPanelChoices:
        myGroup =ArtifactDetailsListChoices(choices: widget.textResponse as List<String>);
        break;
      default:
        ArtifactDetailsInlineNotice(label: '(Response could not be displayed)');
    }


    // assert(myGroup != null);

    return myGroup!;
  }

  @override
  void initState() {
    super.initState();
    dataHeader = widget.question.label;

  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add toggle on/off for enabling Edit
    //  For similar toggle functionality, check ArtifactFloatingFooter
    return Builder(builder: (BuildContext context) {
      return Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (widget.question.isBonus)
                Container(
                  color: buttonBGDisabledGrey,
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Team Question'),
                ),
              Padding(
                padding: const EdgeInsets.only(right: 75.0),
                child: ArtifactDataHeader(label: dataHeader),
              ),
              (widget.textResponse == null && widget.question.type != QuestionType.files)
                ? ArtifactDetailsInlineNotice(label: 'No response provided.')
                : getWidget(),
              SizedBox(height: 12.0),
              Divider(thickness: 2.0, height: 2.0),
            ],
          ),
          Positioned(
            top: 10.0,
            right: 10.0,
            child: GestureDetector(
              onTap: widget.onTapEdit,
              child: Semantics(
                link: true,
                child: Row(
                  children: [
                    Text('Edit', style: TextStyle(color: primaryButtonBlue)),
                    Icon(Icons.keyboard_arrow_right, color: primaryButtonBlue),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
