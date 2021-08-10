class AppUser {
  String uid = "";
  String name = "";
  String email = "";
  String photoURL = "";
  List<dynamic> checklistsId = [];

  AppUser({
    this.uid = "",
    this.name = "",
    this.email = "",
    this.photoURL = "",
    this.checklistsId = const [],
  });

  Map toMap(AppUser user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['photoURL'] = user.photoURL;
    data["checklistsId"] = user.checklistsId;

    return data;
  }

  // Named constructor
  AppUser.fromMap(Map<String, dynamic> mapData) {
    try {
      this.uid = mapData['uid'];
      this.name = mapData['name'];
      this.email = mapData['email'];
      this.photoURL = mapData['photoURL'];
      this.checklistsId = mapData['checklistsId'];
    } catch (err) {
      print('Error in Converting User from Map: $err');
    }
  }
}
