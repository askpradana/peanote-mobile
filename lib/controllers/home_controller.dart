import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/base_string.dart';
import 'package:peanote/constant/key.dart';
import 'package:peanote/data/baseapi.dart';
import 'package:peanote/models/user_model.dart';
import 'package:peanote/services/user_data_storage.dart';

class HomeController extends GetxController {
  RxString token = ''.obs;
  RxString refreshToken = ''.obs;
  RxString userId = ''.obs;
  RxString username = ''.obs;
  RxString userEmail = ''.obs;

  @override
  void onInit() {
    _onSetUserData();
    super.onInit();
  }

  Future<void> _onSetUserData() async {
    UserModel? model = await UserDataStorage.onReadFromSecureStorage();

    if (model != null) {
      token.value = model.token;
      refreshToken.value = model.refreshToken;
      userId.value = model.userData.id;
      username.value = model.userData.username;
      userEmail.value = model.userData.email;
    } else {
      log('No user data found on secure storage.');
    }
  }

  Future<void> onLogout() async {
    Map<String, String> headers = {};
    headers['Authorization'] = 'Bearer ${refreshToken.value}';

    Map<dynamic, dynamic> body = {};
    body['userId'] = userId.value;

    var response =
        await BaseApi().post(BaseString.logout, headers: headers, body: body);

    if (response['message'] == 'Logout successful!') {
      AndroidOptions getAndroidOptions() =>
          const AndroidOptions(encryptedSharedPreferences: true);
      final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
      await storage.delete(key: SecureStorageKey.loginResp);
    }
  }

  Future<void> _onSetNewRefreshToken(String response) async {
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());

    String? json = await storage.read(key: SecureStorageKey.loginResp);
    if (json != null) {
      UserModel userModel = UserModel.fromJson(jsonDecode(json));

      userModel = UserModel(
        token: userModel.token,
        refreshToken: response,
        userData: userModel.userData,
      );

      await storage.write(
          key: SecureStorageKey.loginResp,
          value: jsonEncode(userModel.toJson()));

      _onSetUserData();
    }
  }

  Future<void> onRefreshToken() async {
    Map<String, String> headers = {};
    headers['Authorization'] = 'Bearer ${refreshToken.value}';

    var response =
        await BaseApi().post(BaseString.refreshToken, headers: headers);

    if (response['token'] != null) {
      _onSetNewRefreshToken(response['token']);
    }
  }
}
