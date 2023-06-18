import 'dart:convert';

import 'package:http/http.dart' as http;

/// A helper class to make http requests
class NetworkRequestMaker {
  static const _domainName = '10.0.2.2';
  static const _portNumber = '3001';

  static const _baseURL = 'http://$_domainName:$_portNumber/';

  /// A method that makes a get request.
  /// Returns the body of the response in Map<String, dynamic> form.
  static Future<dynamic> getResponseInJson(String url) async {
    try {
      final rawResponse = await http.get(Uri.parse('$_baseURL$url'));
      if (rawResponse.statusCode == 200) {
        final parsedResponse = jsonDecode(rawResponse.body);

        return parsedResponse;
      }
      throw Exception('Unable to get response');
    } catch (error) {
      throw Exception(error);
    }
  }

  static Future postJsonDataInRequest(
    String url,
    String jsonData,
  ) async {
    try {
      final responseAfterPost = await http.post(
        Uri.parse('$_baseURL$url'),
        body: jsonData,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (responseAfterPost.statusCode == 200) {
        throw Exception('Could not post data');
      }
    }
    catch (error) {
      throw Exception(error);
    }
  }
}
