class AuthUser{
  String token;
  String refreshToken;
  String sub;
  String scopes;
  String userId;
  String firstName;
  String lastName;
  AuthUser();

  factory AuthUser.fromJson(Map json) {
    AuthUser user = AuthUser();
    user.token = json['token'];
    user.refreshToken = json['refreshToken'];
    Map<String, dynamic> data = Map();

    user.sub = data["sub"];
    user.userId = data["userId"];
    user.firstName = data["firstName"];
    user.lastName = data["lastName"];
    user.scopes = data["scopes"][0];

    return user;
  }

}