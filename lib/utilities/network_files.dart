import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

// networking protocol:
// REST API interface
// token-based authentication

const defaultTimeout = 5;

class NetworkFilesHelper {
  final String url;
  final String? token;
  final List<File> files;

  NetworkFilesHelper({
    required this.url,
    this.token,
    required this.files,
  });

  Future makeRequest() async {
    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer $token"
    };

    http.Response response;
    print("network request made to: " + url);


    var request = http.MultipartRequest('POST',Uri.parse(url))
      ..headers.addAll(headers);

    // add all files in the list to the request.
    files.forEach((file) async {
      var myFile = await http.MultipartFile.fromPath("myFile", file.path);
      request.files.add(myFile);
    });

    final http.StreamedResponse streamedResponse = await request.send()
      .timeout(Duration(minutes: defaultTimeout), onTimeout: () {
        throw HttpException("Files upload request timed out");
    });

    response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print("🚨🚨 ${response.statusCode}" + " Error request to URL: $url");
      print('Response body: ${response.body}');

      // TODO: Implement dynamic error handling based on responseCode?
      throw HttpException("${response.statusCode}" + " Error request to URL: $url");
    }
  }
}
