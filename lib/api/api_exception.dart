import 'package:http/http.dart' as http;

class ApiException implements Exception {
  http.Response response;
  String message;
  int statusCode;

  ApiException(this.response, this.message, this.statusCode);
}
