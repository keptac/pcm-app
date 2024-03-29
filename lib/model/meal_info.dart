import 'package:zeucpcm/model/user_role.dart';

class MealInfo {
  String id;
  String mealName;
  String username;
  String checkinStatus;

  MealInfo({
    required this.id,
    required this.mealName,
    required this.username,
    required this.checkinStatus,
  });

  MealInfo copyWith(String id, String mealName, String title, String username,
          String selectedRoom, int roleId, UserRole userRole) =>
      MealInfo(
        id: this.id,
        mealName: '',
        username: '',
        checkinStatus: '',
      );

  factory MealInfo.fromJson(Map<String, dynamic> json) => MealInfo(
      id: json['id'],
      mealName: json['mealName'],
      username: json['username'],
      checkinStatus: json['checkinStatus']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'mealName': mealName,
        'username': username,
        'checkinStatus': checkinStatus,
      };


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mealName': mealName,

      'username': username,
      'checkinStatus': checkinStatus
    };
  }

  void add(MealInfo value) {}
}
