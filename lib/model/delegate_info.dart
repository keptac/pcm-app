class DelegateInfo {
  final int id;
  final String fname;
  final String lname;
  final String username;
  final String email;
  final String image;
  final int checkinStatus;

  const DelegateInfo(
      {required this.id,
      required this.fname,
      required this.lname,
      required this.username,
      required this.email,
      required this.image,
      required this.checkinStatus});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fname': fname,
      'lname': lname,
      'username': username,
      'email': email,
      'image': image,
      'checkinStatus': checkinStatus
    };
  }

  @override
  String toString() {
    return 'DelegateInfo{id: $id, fname: $fname, lname: $lname, username: $username, email: $email, image: $image, checkinStatus: $checkinStatus}';
  }
}
