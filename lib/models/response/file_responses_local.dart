import 'dart:io';

import 'package:spiral_notebook/models/response/file_response_base.dart';
import 'package:spiral_notebook/models/response/file_response_local.dart';

class FileResponsesLocal {
  FileResponsesLocal();

  List<FileResponseLocal> responses = [];

  List<File> get responseDocumentFiles =>
      responses.where((response) => response.type == ArtifactFileResponseType.document)
          .map((e) => e.value)
          .toList();

  List<File> get responseImageFiles =>
    responses.where((response) => response.type == ArtifactFileResponseType.image)
        .map((e) => e.value)
        .toList();

  List<File> get responseVideoFiles =>
      responses.where((response) => response.type == ArtifactFileResponseType.video)
          .map((e) => e.value)
          .toList();

  bool containsLocalPath(String path) => responses.indexWhere(
        (responseLocal) => responseLocal.localPath == path,
  ) != -1;

  List<FileResponseLocal> getResponsesByType(ArtifactFileResponseType type) {
    List<FileResponseLocal> result = [];
    result = responses.where((response) => response.type == type).toList();
    return result;
  }

  void addLocalFromFile(File file, ArtifactFileResponseType type) {

    if (!containsLocalPath(file.path)) {
      // only adds if it's not already in the existing collection!
      responses.add(
          FileResponseLocal.fromFile(file: file, type: type)
      );
    }
  }

  void removeByPath(String path) {
    responses.removeWhere((response) => response.localPath == path);
  }

}