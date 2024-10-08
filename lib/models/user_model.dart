class UserModel {
  final String token;
  final String refreshToken;
  final UserData userData;

  UserModel({
    required this.token,
    required this.refreshToken,
    required this.userData,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json["token"],
      refreshToken: json["refreshToken"],
      userData: UserData.fromJson(json["userData"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "refreshToken": refreshToken,
      "userData": userData.toJson(),
    };
  }
}

class UserData {
  final String id;
  final String username;
  final String email;

  UserData({
    required this.id,
    required this.username,
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json["id"],
      username: json["username"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
    };
  }
}
