class DelegateInfo {
  final String id;
  final String title;
  final String institute;
  final String username;
  final String selectedRoom;

  final String checkinStatus;

  const DelegateInfo(
      {required this.id,
      required this.title,
      required this.institute,
      required this.username,
      required this.selectedRoom,
      required this.checkinStatus});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'institute': institute,
      'username': username,
      'selectedRoom': selectedRoom,
      'checkinStatus': checkinStatus
    };
  }

  @override
  String toString() {
    return 'DelegateInfo{id: $id, title: $title, institute: $institute, username: $username, selectedRoom: $selectedRoom, checkinStatus: $checkinStatus}';
  }
}
