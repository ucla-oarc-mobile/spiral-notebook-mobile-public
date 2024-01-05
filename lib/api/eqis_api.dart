import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:spiral_notebook/models/app_data_version/app_version.dart';
import 'package:spiral_notebook/models/auth/auth_token.dart';
import 'package:spiral_notebook/utilities/network_files.dart';
import 'package:spiral_notebook/utilities/networking.dart';

import 'package:spiral_notebook/local_config.dart';


class EqisAPI {
  // token is stored inside the API since all auth endpoints require a token.
  late AuthToken _authToken;

  late AppDataVersion _appDataVersion;

  static final EqisAPI _singleton = EqisAPI._internal();

  EqisAPI._internal() {
    _authToken = AuthToken();
    _appDataVersion = AppDataVersion();
    print("auth token in constructor $_authToken");
  }

  String get appDataVersion => _appDataVersion.version;
  bool get appDataVersionConflicts => _appDataVersion.version != currentAppDataVersion;
  void overwriteAppDataVersionCache() => _appDataVersion.setVersion(currentAppDataVersion);

  factory EqisAPI() => _singleton;

  Future<bool> isLoggedIn() async {
    if (_authToken.token != '' && _authToken.token !=   '') return true;
    var result = await AuthToken().loadToken();
    if (result == null) result = '';
    _authToken.setToken(result);
    print("the auth token in isLoggedIn is ${_authToken.token}");
    return (_authToken.token != '' && _authToken.token != '');
  }

  Future<dynamic> authPassword({username, password}) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/auth/local',
      token: '',
      body: <String, String>{"identifier": username, "password": password},
      method: 'create',
      customTimeout: Duration(seconds: 15),
    );
    var responseData;
    try {
      responseData = await networkHelper.makeRequest();
    } catch (e) {
      if (e is TimeoutException) throw e;
      throw new HttpException('Unable to login with this email and password.');
    }
    if (responseData == null) {
      // catch any circumstance where endpoint returns empty value.
      throw new HttpException('Unable to login with this email and password.');
    }

    print("auth token in API authPassword ${_authToken.token}");
    _authToken.setToken(responseData['jwt']);

    String? fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken != null && fcmToken.isNotEmpty) {
      // Register FCM token (if any) so the user can receive pushes
      NetworkHelper fcmRegisterHelper = NetworkHelper(
        url: '$eqisURL/messages/register-token',
        token: _authToken.token,
        body: <String, dynamic>{
          "platform": Platform.operatingSystem,
          "osVersion": Platform.operatingSystemVersion,
          "fcmToken": fcmToken,
          "devMode": !kReleaseMode,
        },
        method: 'create',
      );

      try {
        await fcmRegisterHelper.makeRequest();
      } catch (e) {
        if (e is TimeoutException) throw e;
        throw new HttpException('Unable to register push token. Push messaging will not work!');
      }
    }

    // Data ready to send to service
    return responseData;
  }

  Future<dynamic> getNewArtifactId({required String portfolioId}) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/portfolios/$portfolioId/artifacts/responses',
      token: _authToken.token,
      method: 'create',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> submitArtifactTextResponses(
      {required Map <String, dynamic> requestBody, required String portfolioId, required String artifactId }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/portfolios/$portfolioId/artifacts/$artifactId/responses',
      token: _authToken.token,
      method: 'update',
      body: requestBody,
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> copyArtifactToSharedPortfolio(
      {required String sharedPortfolioId, required String artifactId }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/artifacts/$artifactId/share',
      token: _authToken.token,
      method: 'create',
      body: {
        'sharedPortfolioId': sharedPortfolioId,
      },
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> copySharedArtifactToSharedPortfolio(
      {required String sharedPortfolioId, required String sharedArtifactId }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/shared-artifacts/$sharedArtifactId/share',
      token: _authToken.token,
      method: 'create',
      body: {
        'sharedPortfolioId': sharedPortfolioId,
      },
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> deleteArtifact({required String artifactId}) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/artifacts/$artifactId',
      token: _authToken.token,
      method: 'delete',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> gateCheckSharedArtifactEdit({
    required String sharedPortfolioId,
    required String sharedArtifactId,
    required DateTime dateModified,
  }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/shared-portfolios/$sharedPortfolioId/shared-artifacts/$sharedArtifactId/gate-check'
       + '?updated_at=${dateModified.millisecondsSinceEpoch}',
      token: _authToken.token,
      method: 'read',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> submitSharedArtifactTextResponses(
      {required Map <String, dynamic> requestBody, required String sharedPortfolioId, required String sharedArtifactId }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/shared-portfolios/$sharedPortfolioId/shared-artifacts/$sharedArtifactId/responses',
      token: _authToken.token,
      method: 'update',
      body: requestBody,
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> deleteSharedArtifact({required String artifactId}) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/shared-artifacts/$artifactId',
      token: _authToken.token,
      method: 'delete',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> uploadDocument(
      { required File myFile, required String portfolioId, required String artifactId }) async {
    NetworkFilesHelper networkHelper = NetworkFilesHelper(
      url: '$eqisURL/portfolios/$portfolioId/artifacts/$artifactId/documents',
      token: _authToken.token,
      files: <File> [myFile],
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> uploadImage(
      { required File myFile, required String portfolioId, required String artifactId }) async {
    NetworkFilesHelper networkHelper = NetworkFilesHelper(
      url: '$eqisURL/portfolios/$portfolioId/artifacts/$artifactId/images',
      token: _authToken.token,
      files: <File> [myFile],
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> uploadVideo(
      { required File myFile, required String portfolioId, required String artifactId }) async {
    NetworkFilesHelper networkHelper = NetworkFilesHelper(
      url: '$eqisURL/portfolios/$portfolioId/artifacts/$artifactId/videos',
      token: _authToken.token,
      files: <File> [myFile],
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> uploadSharedDocument(
      { required File myFile, required String portfolioId, required String artifactId }) async {
    NetworkFilesHelper networkHelper = NetworkFilesHelper(
      url: '$eqisURL/shared-portfolios/$portfolioId/shared-artifacts/$artifactId/documents',
      token: _authToken.token,
      files: <File> [myFile],
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> uploadSharedImage(
      { required File myFile, required String portfolioId, required String artifactId }) async {
    NetworkFilesHelper networkHelper = NetworkFilesHelper(
      url: '$eqisURL/shared-portfolios/$portfolioId/shared-artifacts/$artifactId/images',
      token: _authToken.token,
      files: <File> [myFile],
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> uploadSharedVideo(
      { required File myFile, required String portfolioId, required String artifactId }) async {
    NetworkFilesHelper networkHelper = NetworkFilesHelper(
      url: '$eqisURL/shared-portfolios/$portfolioId/shared-artifacts/$artifactId/videos',
      token: _authToken.token,
      files: <File> [myFile],
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> deleteDocument(
      { required String fileId, required String portfolioId, required String artifactId }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/portfolios/$portfolioId/artifacts/$artifactId/documents/$fileId',
      token: _authToken.token,
      method: 'delete',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> deleteImage(
      { required String fileId, required String portfolioId, required String artifactId }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/portfolios/$portfolioId/artifacts/$artifactId/images/$fileId',
      token: _authToken.token,
      method: 'delete',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> deleteVideo(
      { required String fileId, required String portfolioId, required String artifactId }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/portfolios/$portfolioId/artifacts/$artifactId/videos/$fileId',
      token: _authToken.token,
      method: 'delete',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> deleteSharedDocument(
      { required String fileId, required String portfolioId, required String artifactId }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/shared-portfolios/$portfolioId/shared-artifacts/$artifactId/documents/$fileId',
      token: _authToken.token,
      method: 'delete',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> deleteSharedImage(
      { required String fileId, required String portfolioId, required String artifactId }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/shared-portfolios/$portfolioId/shared-artifacts/$artifactId/images/$fileId',
      token: _authToken.token,
      method: 'delete',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> deleteSharedVideo(
      { required String fileId, required String portfolioId, required String artifactId }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/shared-portfolios/$portfolioId/shared-artifacts/$artifactId/videos/$fileId',
      token: _authToken.token,
      method: 'delete',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  bool clearLoginToken() {

    try {
      _authToken.setToken('');
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<dynamic> getContactInfo() async {
    var token = await AuthToken().loadToken();

    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/contact',
      token: token,
      method: 'read',
      body: {},
    );

    var responseData;
    try {
      responseData = await networkHelper.makeRequest();
    } catch (e) {
      print(e);
      throw new HttpException('Unable to retrieve contact info.');
    }

    if (responseData == null) {
      // catch any circumstance where endpoint returns empty value.
      throw new HttpException('Unable to retrieve contact info.');
    }

    return responseData;
  }


  Future<dynamic> fetchArtifacts() async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/artifacts',
      token: _authToken.token,
      method: 'read',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> fetchPortfolios() async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/portfolios',
      token: _authToken.token,
      method: 'read',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> fetchSharedPortfolios() async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/shared-portfolios',
      token: _authToken.token,
      method: 'read',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> fetchSharedArtifacts() async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/shared-artifacts',
      token: _authToken.token,
      method: 'read',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> fetchSharedArtifactsComments() async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/comments',
      token: _authToken.token,
      method: 'read',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> addSharedArtifactComment({
    required String sharedArtifactId,
    required String commentText,
  }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/comments',
      token: _authToken.token,
      method: 'create',
      body: <String, String>{
        "sharedArtifact": sharedArtifactId,
        "text": commentText,
      },
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> editSharedArtifactComment({
    required String commentId,
    required String commentText,
  }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/comments/$commentId',
      token: _authToken.token,
      method: 'update',
      body: {
        "text": commentText,
      },
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }


  Future<dynamic> deleteSharedArtifactComment({required String commentId}) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/comments/$commentId',
      token: _authToken.token,
      method: 'delete',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> fetchSharedArtifactsReactions() async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/reactions',
      token: _authToken.token,
      method: 'read',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> addSharedArtifactReaction({
    required String sharedArtifactId,
    required String reactionValue,
  }) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/reactions',
      token: _authToken.token,
      method: 'create',
      body: <String, String>{
        "sharedArtifact": sharedArtifactId,
        "value": reactionValue,
      },
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> deleteSharedArtifactReaction({required String reactionId}) async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/reactions/$reactionId',
      token: _authToken.token,
      method: 'delete',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> fetchUserDetails() async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/users/me',
      token: _authToken.token,
      method: 'read',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> fetchNotificationsList() async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/messages/list',
      token: _authToken.token,
      method: 'read',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    return responseData;
  }

  Future<dynamic> unregisterPushToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken != null && fcmToken.isNotEmpty) {
      // Un-register FCM token (if any) after logout to stop pushes
      NetworkHelper networkHelper = NetworkHelper(
        url: '$eqisURL/messages/unregister-token',
        token: _authToken.token,
        body: <String, dynamic>{
          "fcmToken": fcmToken,
        },
        method: 'create',
      );
      await networkHelper.makeRequest();
    }
  }


  Future<dynamic> refreshLoginToken() async {
    NetworkHelper networkHelper = NetworkHelper(
      url: '$eqisURL/token/refresh',
      token: _authToken.token,
      method: 'create',
      body: {},
    );
    var responseData = await networkHelper.makeRequest();

    if (responseData == null) {
      return null;
    }
    if (responseData['jwt'] != null)
      _authToken.setToken(responseData['jwt']);
    return responseData;
  }

  Future<dynamic> markAsRead(messageId) async {
    try {
      NetworkHelper networkHelper = NetworkHelper(
        url: '$eqisURL/messages/mark-as-read',
        token: _authToken.token,
        body: <String, dynamic>{
          "messageId": messageId,
        },
        method: 'create',
      );
      await networkHelper.makeRequest();
    } catch (e) {
      return false;
    }

    return true;
  }
}
