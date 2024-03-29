class SignUpModel {
  String id;
  String username;
  String password;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String idNumber;



  SignUpModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.idNumber,
  });


  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      idNumber: json['idNumber'] as String,

    );
  }
}
