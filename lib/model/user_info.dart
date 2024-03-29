import 'package:zeucpcm/model/user_role.dart';

class UserInfo {
  String id;
  String institute;
  String title;
  String username;
  String selectedRoom;
  String checkinStatus;
  int roleId;
  UserRole userRole;

  UserInfo(
      {required this.id,
      required this.institute,
      required this.title,
      required this.username,
      required this.selectedRoom,
      required this.checkinStatus,
      required this.roleId,
      required this.userRole});

  UserInfo copyWith(String id, String institute, String title, String username,
          String selectedRoom, int roleId, UserRole userRole) =>
      UserInfo(
          id: this.id,
          institute: '',
          title: '',
          username: '',
          selectedRoom: '',
          checkinStatus: '',
          roleId: this.roleId,
          userRole: this.userRole);

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
      id: json['id'],
      institute: json['institute'],
      title: json['title'],
      username: json['username'],
      selectedRoom: json['selectedRoom'],
      checkinStatus: json['checkinStatus'],
      roleId: json['role_id'],
      userRole: UserRole.fromJson(json['user_roles']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'institute': institute,
        'title': title,
        'username': username,
        'selectedRoom': selectedRoom,
        'checkinStatus': checkinStatus,
        'role_id': roleId,
        'user_roles': UserRole
      };
}
