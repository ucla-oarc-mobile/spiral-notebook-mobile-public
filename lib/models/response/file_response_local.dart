
import 'dart:io';

import 'package:spiral_notebook/models/response/file_response_base.dart';

class FileResponseLocal extends FileResponseBase {
  final String localPath;
  final File value;

  FileResponseLocal.fromFile({required File file, required ArtifactFileResponseType type})
      : value = file,
        localPath = file.path,
        super.fromFile(file, type);
}