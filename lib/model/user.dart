class User {
  final String uid;
  final String name;
  final String photoUrl;
  final List<Map<String, dynamic>> goals;
  final List<String> chatWith;
  final int role;
  static const role_caretaker = 1;
  static const role_donor = 2;

  User({this.uid, this.name, this.photoUrl, this.goals, this.chatWith, this.role});
}
