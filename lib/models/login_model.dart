class LoginModel {
  String id;
  String username;
  String password;

  LoginModel({required this.id, required this.username, required this.password});
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
    );
  }
}
