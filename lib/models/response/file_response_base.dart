
import 'dart:io';

import 'package:intl/intl.dart';

enum ArtifactFileResponseType {
  document,
  image,
  video,
}

abstract class FileResponseBase {
  final ArtifactFileResponseType type;
  final int sizeBytes;
  final String name;
  final DateTime dateCreated;

  static int getFileBytes(File file) {
    int result = 0;

    try {
      // refactor to add custom File model with metadata,
      // save bytes when first read.
      result = file.readAsBytesSync().lengthInBytes;
    } catch (e) {
      print('$e');
      result = 0;
    }

    return result;
  }

  static int getResponseBytes(Map<String, dynamic> responseJson) {
    int result = 0;

    num responseKb = responseJson['size'];

    // convert KB to bytes
    result = (responseKb * 1024).round();

    return result;
  }

  String get formattedDateCreated {
    var formatter = new DateFormat('MM-dd-yy');
    String date = formatter.format(dateCreated.toLocal());
    return date;
  }

  String get bytesFormatted {
    int bytesDisplay = 0;

    if (sizeBytes > 0)
      bytesDisplay = (sizeBytes > 1048576)
          ? (sizeBytes / 1048576).round()
          : (sizeBytes / 1024).round();
    return '$bytesDisplay';
  }

  String get bytesSuffix => (sizeBytes > 1048576) ? "MB" : "KB";

  String get fileNameShortened => _fileNameShortener(name, 20);

  String get fileNameExtraShortened => _fileNameShortener(name, 12);


  String _fileNameShortener(String fullName, int maxLength) {
    String shortName = fullName;
    if (shortName.length > maxLength) {
      // file name too long, cut out the middle
      // but include the extension.
      shortName = name
          .substring(0, maxLength - 4 - 1) + "…" +
          name.substring(
              name.length - 4,
              name.length);
    }
    return shortName;
  }


  FileResponseBase.fromFile(File file, ArtifactFileResponseType type)
      : dateCreated = DateTime.now(),
        type = type,
        name = file.path.split('/').last,
        sizeBytes = getFileBytes(file);

  FileResponseBase.fromResponse(Map<String, dynamic> responseJson, ArtifactFileResponseType type)
      : dateCreated = DateTime.parse(responseJson['created_at']),
        type = type,
        name = responseJson['name'],
        sizeBytes = getResponseBytes(responseJson);

}