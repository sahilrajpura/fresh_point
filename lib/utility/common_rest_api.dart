import 'package:http/http.dart' as http;

class ApiServices {
  // Get Method With Token Function
  static Future<http.Response> getPublicAuthToken(
    String uri,
    String token,
  ) async {
    try {
      http.Response response = await http.get(
        Uri.parse(uri),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  // Get Method Without Token Function
  static Future<http.Response> getPublicAuth(String uri) async {
    try {
      http.Response response = await http.get(
        Uri.parse(uri),
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  // Post Method With Token Function
  static Future<http.Response> postPublicAuthToken(
    String uri,
    dynamic body,
    String token,
  ) async {
    try {
      http.Response response = await http.post(
        Uri.parse(uri),
        body: body,
        // headers: {'Authorization': 'Bearer $token'},
        headers: {
          'Authorization': token,
          'Accept': 'application/json',
        },
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<http.Response> postAuthTokenWithHeader(
    String url,
    Map<String, dynamic> params,
    String token,
  ) async {
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: params,
      );

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Post Method Without Token Function
  static Future<http.Response> postPublicSingle(
    String uri,
    dynamic body,
  ) async {
    try {
      http.Response response = await http.post(
        Uri.parse(uri),
        body: body,
      );
      return response;
    } catch (e) {
      // throw toasterMessage(e.toString(), Danger);
      throw e.toString();
    }
  }
}
