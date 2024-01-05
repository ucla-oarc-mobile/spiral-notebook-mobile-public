import 'dart:io';

import 'package:spiral_notebook/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// networking protocol:
// REST API interface
// token-based authentication

class NetworkHelper {
  final String url;
  final String? token;
  final Map<String, dynamic> body;
  final String method;
  final Duration? customTimeout;

  NetworkHelper({
    required this.url,
    this.token,
    required this.body,
    required this.method,
    this.customTimeout,
  });

  Future makeRequest() async {
    Map<String, String> headers = (token == '')
        ? <String, String>{
      "content-type": "application/json",
    }
        : <String, String>{
      "content-type": "application/json",
      "Authorization": "Bearer $token"
    };

    http.Response response;
    print("network request made to: " + url);

    final Duration requestTimeout = customTimeout ?? defaultNetworkTimeout;

    switch (method) {
      case 'create':
        {
          response = await http
              .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
              .timeout(requestTimeout);
        }
        break;
      case 'read':
        {
          response = await http
              .get(Uri.parse(url), headers: headers)
              .timeout(requestTimeout);
        }
        break;
      case 'update':
        {
          response = await http
              .put(Uri.parse(url), headers: headers, body: jsonEncode(body))
              .timeout(requestTimeout);
        }
        break;
      case 'delete':
        {
          response = await http
              .delete(Uri.parse(url), headers: headers)
              .timeout(requestTimeout);
        }
        break;
      default:
        throw new Exception('invalid response type: $method');
    }


    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
      // TODO: add handler to logout blocked user.
      // {"statusCode":401,"error":"Unauthorized","message":"Your account has been blocked by the administrator."}
    } else {
      print("🚨🚨 ${response.statusCode}" + " Error request to URL: $url");
      print('Response body: ${response.body}');

      // TODO: Implement dynamic error handling based on responseCode?
      throw HttpException("${response.statusCode}" + " Error request to URL: $url");
    }
  }
}
