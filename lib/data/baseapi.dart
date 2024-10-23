import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
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
        // throw ApiException('Client error: ${response.reasonPhrase}',
        //     statusCode: statusCode);
        dynamic decodedBody = json.decode(body);
        String message = decodedBody['error'];

        Get.defaultDialog(
          title: 'Error',
          content: Text('${[statusCode]} $message'),
          textConfirm: 'Close',
          onConfirm: () {
            Get.back();
          },
        );
      } else if (statusCode >= 500) {
        // throw ApiException('Server error: ${response.reasonPhrase}',
        //     statusCode: statusCode);
        dynamic decodedBody = json.decode(body);
        String message = decodedBody['error'];

        Get.defaultDialog(
          title: 'Error',
          content: Text('${[statusCode]} $message'),
          textConfirm: 'Close',
          onConfirm: () {
            Get.back();
          },
        );
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
    log('Headers: $headers');
    log('Body: $body');

    return _makeRequest(
      () => http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type':
              'application/json', //TODO : error 500 on refresh token
          ...?headers,
        },
        body: json.encode(body),
      ),
    );
  }

  Future<http.StreamedResponse> postMultipart(
    String endpoint, {
    Map<String, String>? headers,
    required Map<String, dynamic> body,
    required PlatformFile file,
    required String bearerToken,
  }) async {
    log('POST request to: $endpoint');
    log('Body: $body');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(endpoint),
    );
    request.headers.addAll({
      ...?headers,
      'Authorization': 'Bearer $bearerToken',
    });
    String? mimeType =
        lookupMimeType(file.path ?? '', headerBytes: file.bytes) ??
            'application/octet-stream';
    MediaType mediaType = MediaType.parse(mimeType);
    if (file.bytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'audio',
        file.bytes!,
        filename: file.name,
        contentType: mediaType,
      ));
    } else if (file.path != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'audio',
        file.path!,
        contentType: mediaType,
      ));
    } else {
      throw Exception('No bytes or path found for selected file');
    }
    body.forEach((key, value) {
      request.fields[key] = value.toString();
    });
    log('Fields: ${request.fields}');
    log('Headers: ${request.headers}');
    log('Files: ${request.files.map((f) => f.filename).toList()}');
    return await request.send();
  }
}
