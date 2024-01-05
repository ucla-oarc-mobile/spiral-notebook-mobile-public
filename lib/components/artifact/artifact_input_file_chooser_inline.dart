import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spiral_notebook/api/response_object_with_parent_cache.dart';
import 'package:spiral_notebook/components/artifact/artifact_files_list_preview.dart';
import 'package:spiral_notebook/components/artifact/artifact_files_images_preview.dart';
import 'package:spiral_notebook/models/response/file_response_base.dart';
import 'package:spiral_notebook/models/response/file_response_local.dart';
import 'package:spiral_notebook/models/response/file_response_remote.dart';
import 'package:spiral_notebook/models/response/file_responses_transient_editor.dart';
import 'package:spiral_notebook/providers/artifacts_provider.dart';
import 'package:spiral_notebook/providers/shared_artifacts_provider.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/utilities/loading.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';


class ArtifactInputFileChooserInline extends ConsumerStatefulWidget {
  const ArtifactInputFileChooserInline({
    Key? key,
    required this.onFilesChosen,
    required this.onFileRemoved,
    required this.fileType,
  }) : super(key: key);

  final Function(List<dynamic>) onFilesChosen;
  final Function(dynamic) onFileRemoved;

  final ArtifactFileResponseType fileType;



  @override
  _ArtifactInputFileChooserInlineState createState() => _ArtifactInputFileChooserInlineState();
}

class _ArtifactInputFileChooserInlineState extends ConsumerState<ArtifactInputFileChooserInline> {

  late Map<String, Widget> mediaSourceOptions;

  String selectedMediaSource = 'gallery';

  late String typeLabel;

  FileResponsesTransientEditor? currentFileResponses;

  late List<dynamic> previewedFileResponses;

  @override
  void initState() {
    super.initState();

    currentFileResponses = ref.read(fileResponsesTransientEditorProvider);

    refreshPreviews();

    mediaSourceOptions = {
      'gallery': Text('$typeLabel from Gallery'),
      'capture': Text('Capture $typeLabel'),
    };

  }

  void refreshPreviews() {
    switch (widget.fileType) {
      case ArtifactFileResponseType.document:
        typeLabel = 'Document';
        previewedFileResponses = currentFileResponses!.responseDocumentsAll;
        break;
      case ArtifactFileResponseType.image:
        typeLabel = 'Photo';
        previewedFileResponses = currentFileResponses!.responseImagesAll;
        break;
      case ArtifactFileResponseType.video:
        typeLabel = 'Video';
        previewedFileResponses = currentFileResponses!.responseVideosAll;
        break;
    }

  }

  Future<void> pickMedia(ArtifactFileResponseType type, mediaSource) async {
    bool galleryChosen = (mediaSource == 'gallery');

    if (type == ArtifactFileResponseType.image && galleryChosen) {
      // only image + gallery allows multi-select.
      // call image multi select and add multiple image files.

      List<XFile>? pickedImages;

      pickedImages = await ImagePicker().pickMultiImage(
        maxWidth: 2048,
        maxHeight: 2048,
      );

      // User canceled the picker
      if (pickedImages == null) return;

      List<File> pickedImagesFiles = pickedImages.map((pickedImage) => File(pickedImage.path)).toList();

      pickedImagesFiles.forEach((pickedImageFile) {
        // only add files if the path isn't duplicated in the selected files list
        addResponseFile(pickedImageFile, type);
      });

    } else {
      // all other media pickers require a single media selection.

      XFile? pickedMedia;

      if (type == ArtifactFileResponseType.image) {
        pickedMedia = await ImagePicker().pickImage(
          maxWidth: 2048,
          maxHeight: 2048,
          source: ImageSource.camera,
        );
      } else {
        pickedMedia = await ImagePicker().pickVideo(source: galleryChosen ? ImageSource.gallery : ImageSource.camera);
      }

      // User canceled the picker
      if (pickedMedia == null) return;

      File pickedMediaFile = File(pickedMedia.path);

      addResponseFile(pickedMediaFile, type);

    }
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type:  FileType.any,
      allowMultiple: true,
    );

    // User canceled the picker
    if (result == null) return;

    List<PlatformFile> _fileResultsMeta = result.files;
    List<File> pickedDocumentFiles = _fileResultsMeta.map((file) => File(file.path!)).toList();

    pickedDocumentFiles.forEach((pickedDocumentFile) {
      // only add files if the path isn't duplicated in the selected files list
      addResponseFile(pickedDocumentFile, ArtifactFileResponseType.document);
    });
  }

  void addResponseFile(File myFile, ArtifactFileResponseType responseType) {
    currentFileResponses?.responsesLocal.addLocalFromFile(myFile, responseType);
  }

  Future<void> deleteRemoteFile(dynamic fileResponse) async {
    try {
      showLoading(context, 'Deleting uploaded file...');
      // deleteRemote should return response bundle with JSON.
      // send the bundle here so the artifact
      // can update its own cache.
      ResponseObjectWithParentCache? responseBundle = await currentFileResponses?.deleteRemote(fileResponse as FileResponseRemote);
      dismissLoading(context);
      if (currentFileResponses?.isSharedArtifact ?? false) {
        ref.read(sharedArtifactsProvider.notifier).updateWithRemovedFile(
          sharedArtifactId: currentFileResponses!.universalArtifactId!,
          fileResponse: fileResponse,
          sharedArtifactJSON: responseBundle?.parentJSON ?? {},
        );
      } else {
        ref.read(artifactsProvider.notifier).updateWithRemovedFile(
          artifactId: currentFileResponses!.universalArtifactId!,
          fileResponse: fileResponse,
          artifactJSON: responseBundle?.parentJSON ?? {},
        );
      }
      widget.onFileRemoved(fileResponse);
    } catch (e) {
      Navigator.pop(context);
      String message = (e is HttpException)
          ? e.message
          : "Error, could not delete uploaded file.";
      showSnackAlert(context, message);
      dismissLoading(context);
      // throw another exception so the wrapping Dismissible cancels too
      throw Exception('cancel the Dismissible');
    }
  }

  void onPreviewFileRemoved(dynamic fileResponse) async {
    // file response is either a FileResponseLocal or FileResponseRemote.
    // handle these scenarios differently.
    if (fileResponse.runtimeType == FileResponseLocal) {
      currentFileResponses?.deleteLocal(fileResponse as FileResponseLocal);
      widget.onFileRemoved(fileResponse);
    } else if (fileResponse.runtimeType == FileResponseRemote) {
      await deleteRemoteFile(fileResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Force video capture button to hide on Android.
    // Added because of issues with captured Android video file format.
    // bool hideVideoCapture = Platform.isAndroid && widget.fileType == ArtifactFileResponseType.video;

    // update: Disable video capture for *all* platforms
    bool hideVideoCapture = widget.fileType == ArtifactFileResponseType.video;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (widget.fileType != ArtifactFileResponseType.document)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChooserButton(
                  myText: "Choose $typeLabel(s)",
                  myOnPressed: () async {
                    try {

                      switch (widget.fileType) {
                        case ArtifactFileResponseType.image:
                          showLoading(context, 'Choosing Image(s)...');

                          await pickMedia(widget.fileType, 'gallery');
                          break;
                        case ArtifactFileResponseType.video:
                          showLoading(context, 'Choosing Video(s)...');

                          await pickMedia(widget.fileType, 'gallery');
                          break;
                        case ArtifactFileResponseType.document:
                          // this doesn't happen.
                          break;
                      }
                      setState(() {
                        refreshPreviews();
                      });
                      widget.onFilesChosen(previewedFileResponses);
                    } catch (e) {
                      String message = (e is FormatException)
                          ? e.message
                          : "Failed to select $typeLabel, please try again.";
                      showSnackAlert(context, message);
                      setState(() {
                        refreshPreviews();
                      });
                    }
                    dismissLoading(context);
                  }
              ),
              if (!hideVideoCapture)
                ChooserButton(
                    myText: "Capture $typeLabel",
                    myOnPressed: () async {
                      try {

                        switch (widget.fileType) {
                          case ArtifactFileResponseType.image:
                            showLoading(context, 'Capturing Image(s)...');

                            await pickMedia(widget.fileType, 'capture');
                            break;
                          case ArtifactFileResponseType.video:
                            showLoading(context, 'Capturing Video(s)...');

                            await pickMedia(widget.fileType, 'capture');
                            break;
                          case ArtifactFileResponseType.document:
                          // this doesn't happen.
                            break;
                        }
                        setState(() {
                          refreshPreviews();
                        });
                        widget.onFilesChosen(previewedFileResponses);
                      } catch (e) {
                        String message = (e is FormatException)
                            ? e.message
                            : "Failed to select $typeLabel, please try again.";
                        showSnackAlert(context, message);
                        setState(() {
                          refreshPreviews();
                        });
                      }
                      dismissLoading(context);
                    }
                ),
            ]
          ),
          (widget.fileType == ArtifactFileResponseType.image)
              ? ArtifactFilesImagesPreview(
            previewedFileResponses: previewedFileResponses,
            onFileRemoved: onPreviewFileRemoved,
          )
              : ArtifactFilesListPreview(
            fileType: widget.fileType,
            previewedFileResponses: previewedFileResponses,
            onFileRemoved: onPreviewFileRemoved,
          ),
        if (widget.fileType == ArtifactFileResponseType.document)
          ChooserButton(
              myText: "Choose $typeLabel(s)",
              myOnPressed: () async {
                try {
                  showLoading(context, 'Choosing Document(s)...');
                  await pickFiles();
                  setState(() {
                    refreshPreviews();
                  });
                  widget.onFilesChosen(previewedFileResponses);

                } catch (e) {
                  String message = (e is FormatException)
                      ? e.message
                      : "Failed to select $typeLabel, please try again.";
                  showSnackAlert(context, message);
                  setState(() {
                    refreshPreviews();
                  });
                }

                dismissLoading(context);
              }
          ),
      ],
    );
  }
}

class ChooserButton extends StatelessWidget {
  ChooserButton({
    this.myText = '',
    this.myOnPressed,
  });

  final String myText;
  final void Function()? myOnPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      child: ElevatedButton(
        onPressed: myOnPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0.0, backgroundColor: Colors.white,
          side: BorderSide(width: 1.0, color: primaryButtonBlue),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          padding: EdgeInsets.all(18.0),
        ),
        child: Text(
          myText,
          style: TextStyle(color: primaryButtonBlue,),
        ),
      ),
    );
  }
}

