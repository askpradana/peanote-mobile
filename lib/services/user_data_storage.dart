import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peanote/constant/key.dart';
import 'package:peanote/models/user_model.dart';

class UserDataStorage {
  static Future<dynamic> onReadFromSecureStorage() async {
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());

    String? json = await storage.read(key: SecureStorageKey.loginResp);
    if (json != null) {
      return UserModel.fromJson(jsonDecode(json));
    }
    return null;
  }
}
