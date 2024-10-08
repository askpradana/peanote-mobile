import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PlatformFile? _selectedFile;
  final TextEditingController _topicsController = TextEditingController();
  final TextEditingController _notesLanguageController =
      TextEditingController();
  final TextEditingController _audioLanguagesController =
      TextEditingController();
  bool _isUploading = false;

  Future<void> _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'aac', 'm4a'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single;
      });
    }
  }

  Future<void> _uploadData() async {
    if (_selectedFile == null ||
        _topicsController.text.isEmpty ||
        _notesLanguageController.text.isEmpty ||
        _audioLanguagesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a file and fill all fields.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      Map<String, dynamic> body = {
        'topics': _topicsController.text,
        'notesLanguage': _notesLanguageController.text,
        'audioLanguages': _audioLanguagesController.text,
      };

      http.StreamedResponse response = await postMultipart(
        'http://10.0.2.2:9040/api/v1/prompt/upload',
        body: body,
        file: _selectedFile!,
      );

      log('Upload response: ${response.statusCode}');
      String responseBody = await response.stream.bytesToString();
      log('Response body: $responseBody');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Upload failed with status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      log('Error during upload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during upload.')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<http.StreamedResponse> postMultipart(
    String endpoint, {
    Map<String, String>? headers,
    required Map<String, dynamic> body,
    required PlatformFile file,
  }) async {
    log('POST request to: $endpoint');
    log('Body: $body');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(endpoint),
    );

    request.headers.addAll({
      ...?headers,
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

  @override
  void dispose() {
    _topicsController.dispose();
    _notesLanguageController.dispose();
    _audioLanguagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Upload Example'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: _pickAudioFile,
                child: const Text('Select Audio File'),
              ),
              if (_selectedFile != null)
                Text(
                  'Selected File: ${_selectedFile!.name}',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _topicsController,
                decoration: const InputDecoration(
                  labelText: 'Topics',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _notesLanguageController,
                decoration: const InputDecoration(
                  labelText: 'Notes Language',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _audioLanguagesController,
                decoration: const InputDecoration(
                  labelText: 'Audio Languages',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _isUploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _uploadData,
                      child: const Text('Upload'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
