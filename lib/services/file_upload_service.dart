import 'dart:io';

import 'package:spiral_notebook/api/eqis_api.dart';
import 'package:spiral_notebook/models/response/file_response_base.dart';


class FileUploadService {
  final _upload = EqisAPI();

  Future<dynamic> uploadFileByType({
    required String portfolioId,
    required File myFile,
    required String artifactId,
    required ArtifactFileResponseType fileType,
    bool isSharedArtifact = false,
  }) async {
    dynamic result;
    if (isSharedArtifact) {
      switch (fileType) {
        case ArtifactFileResponseType.document:
          result = await _upload.uploadSharedDocument(myFile: myFile, portfolioId: portfolioId, artifactId: artifactId);
          return result;
        case ArtifactFileResponseType.image:
          result = await _upload.uploadSharedImage(myFile: myFile, portfolioId: portfolioId, artifactId: artifactId);
          return result;
        case ArtifactFileResponseType.video:
          result = await _upload.uploadSharedVideo(myFile: myFile, portfolioId: portfolioId, artifactId: artifactId);
          return result;
      }
    } else {
      switch (fileType) {
        case ArtifactFileResponseType.document:
          result = await _upload.uploadDocument(myFile: myFile, portfolioId: portfolioId, artifactId: artifactId);
          return result;
        case ArtifactFileResponseType.image:
          result = await _upload.uploadImage(myFile: myFile, portfolioId: portfolioId, artifactId: artifactId);
          return result;
        case ArtifactFileResponseType.video:
          result = await _upload.uploadVideo(myFile: myFile, portfolioId: portfolioId, artifactId: artifactId);
          return result;
      }
    }
  }

  Future<dynamic> deleteFile({
    required String portfolioId,
    required String artifactId,
    required String fileId,
    required ArtifactFileResponseType fileType,
    bool isSharedArtifact = false,
  }) async {
    dynamic submitResult;
    if (isSharedArtifact) {
      switch (fileType) {
        case ArtifactFileResponseType.document:
          submitResult = await _upload.deleteSharedDocument(portfolioId: portfolioId, artifactId: artifactId, fileId: fileId);
          return submitResult;
        case ArtifactFileResponseType.image:
          submitResult = await _upload.deleteSharedImage(portfolioId: portfolioId, artifactId: artifactId, fileId: fileId);
          return submitResult;
        case ArtifactFileResponseType.video:
          submitResult = await _upload.deleteSharedVideo(portfolioId: portfolioId, artifactId: artifactId, fileId: fileId);
          return submitResult;
      }
    } else {
      switch (fileType) {
        case ArtifactFileResponseType.document:
          submitResult = await _upload.deleteDocument(portfolioId: portfolioId, artifactId: artifactId, fileId: fileId);
          return submitResult;
        case ArtifactFileResponseType.image:
          submitResult = await _upload.deleteImage(portfolioId: portfolioId, artifactId: artifactId, fileId: fileId);
          return submitResult;
        case ArtifactFileResponseType.video:
          submitResult = await _upload.deleteVideo(portfolioId: portfolioId, artifactId: artifactId, fileId: fileId);
          return submitResult;
      }
    }
  }
}