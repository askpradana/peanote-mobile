import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:peanote/constant/base_string.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status Code: $statusCode)' : ''}';
}

class BaseApi extends GetxController {
  final String baseUrl = BaseString.baseUrl;

  Future<dynamic> _handleResponse(http.Response response) async {
    try {
      final statusCode = response.statusCode;
      final body = response.body;

      if (statusCode >= 200 && statusCode < 300) {
        return json.decode(body);
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ApiException('Client error', statusCode: statusCode);
      } else if (statusCode >= 500) {
        throw ApiException('Server error', statusCode: statusCode);
      } else {
        throw ApiException('Unexpected status code', statusCode: statusCode);
      }
    } on FormatException {
      throw ApiException('Invalid response format');
    }
  }

  Future<dynamic> _makeRequest(
      Future<http.Response> Function() requestFunction) async {
    try {
      final response = await requestFunction();
      return await _handleResponse(response);
    } on http.ClientException {
      throw ApiException('Network error or invalid URL');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    return _makeRequest(
      () => http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ),
    );
  }

  Future<dynamic> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    return _makeRequest(
      () => http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(body),
      ),
    );
  }
}
