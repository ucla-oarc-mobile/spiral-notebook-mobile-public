import 'package:spiral_notebook/local_config.dart';
import 'package:spiral_notebook/models/response/file_response_base.dart';

enum ArtifactFilePreviewUrlType {
  large,
  link,
  medium,
  thumbnail,
}

class FileResponseRemote extends FileResponseBase {
  final String remoteId;
  final String namePrefix;
  final Map<ArtifactFilePreviewUrlType, String> previewUrlsByType;

  static String getIdFromResponse(Map<String, dynamic> responseJson) {
    String result = '';
    result = '${responseJson['id']}';
    return result;
  }

  String get linkPath => serverAssetsRootURL + '${previewUrlsByType[ArtifactFilePreviewUrlType.link]}';
  String get imageLargePath => serverAssetsRootURL + '${previewUrlsByType[ArtifactFilePreviewUrlType.large]}';
  String get imageMediumPath => serverAssetsRootURL + '${previewUrlsByType[ArtifactFilePreviewUrlType.medium]}';
  String get imageThumbnailPath => serverAssetsRootURL + '${previewUrlsByType[ArtifactFilePreviewUrlType.thumbnail]}';

  static Map<ArtifactFilePreviewUrlType, String> getPreviewsFromResponse(Map<String, dynamic> responseJson, ArtifactFileResponseType type) {
    Map<ArtifactFilePreviewUrlType, String> result = {};

    result[ArtifactFilePreviewUrlType.link] = responseJson['url'];

    switch (type) {
      case ArtifactFileResponseType.document:
        // TODO: Add any extra document metadata not present in other formats.
        break;
      case ArtifactFileResponseType.image:
        result[ArtifactFilePreviewUrlType.large] = responseJson['formats']['large']['url'];
        result[ArtifactFilePreviewUrlType.medium] = responseJson['formats']['medium']['url'];
        result[ArtifactFilePreviewUrlType.thumbnail] = responseJson['formats']['thumbnail']['url'];

        // force the "link" version of the image to be the large thumbnail, plus a ".html" suffix
        result[ArtifactFilePreviewUrlType.link] = '/images' + responseJson['url'] + '.html';

        break;
      case ArtifactFileResponseType.video:
      // TODO: Add any extra video metadata not present in other formats.
        result[ArtifactFilePreviewUrlType.link] = '/videos' + responseJson['url'] + '.html';
        break;
    }
    return result;
  }

  FileResponseRemote.fromResponse({required Map<String, dynamic> responseJson, required ArtifactFileResponseType type})
      : remoteId = getIdFromResponse(responseJson),
        previewUrlsByType = getPreviewsFromResponse(responseJson, type),
        namePrefix = '${responseJson['caption'] ?? ''}',
        super.fromResponse(responseJson, type);
}