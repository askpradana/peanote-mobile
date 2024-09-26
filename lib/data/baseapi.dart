import 'dart:developer';

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
    log('Response status code: ${response.statusCode}');
    log('Response body: ${response.body}');
    // debugPrint('Response headers: ${response.headers}');

    try {
      final statusCode = response.statusCode;
      final body = response.body;

      if (statusCode >= 200 && statusCode < 300) {
        return json.decode(body);
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ApiException('Client error: ${response.reasonPhrase}',
            statusCode: statusCode);
      } else if (statusCode >= 500) {
        throw ApiException('Server error: ${response.reasonPhrase}',
            statusCode: statusCode);
      } else {
        throw ApiException('Unexpected status code: ${response.reasonPhrase}',
            statusCode: statusCode);
      }
    } on FormatException catch (e) {
      throw ApiException(
        'Invalid response format: $e',
      );
    }
  }

  Future<dynamic> _makeRequest(
      Future<http.Response> Function() requestFunction) async {
    try {
      final response = await requestFunction();
      return await _handleResponse(response);
    } on http.ClientException catch (e) {
      // log('ClientException: $e');
      throw ApiException('Network error or invalid URL: ${e.message}');
    } on ApiException catch (e) {
      log('ApiException: $e');
      rethrow;
    } catch (e) {
      // log('Unexpected error: $e');
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    log('GET request to: $baseUrl$endpoint');
    // debugPrint('Headers: $headers');

    return _makeRequest(
      () => http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
      ),
    );
  }

  Future<dynamic> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    log('POST request to: $baseUrl$endpoint');
    // debugPrint('Headers: $headers');
    log('Body: $body');

    return _makeRequest(
      () => http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: json.encode(body),
      ),
    );
  }
}
