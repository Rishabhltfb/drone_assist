class CheckList {
  String id = "";
  String userid = "";
  String title = "";
  String description = "";
  List<dynamic> checkpoints = [];

  CheckList({
    this.id = "",
    this.userid = "",
    this.title = "",
    this.description = "",
    this.checkpoints = const [],
  });

  Map toMap(CheckList checkList) {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = checkList.id;
    data['userid'] = checkList.userid;
    data['title'] = checkList.title;
    data['description'] = checkList.description;
    data["checkpoints"] = checkList.checkpoints;

    return data;
  }

  CheckList.fromMap(Map<String, dynamic> map) {
    try {
      this.id = map["id"];
      this.userid = map["userid"];
      this.title = map["title"];
      this.description = map["description"];
      this.checkpoints = map["checkpoints"];
    } catch (err) {
      print("Error in parsing JSON to Checklist Object: " + err.toString());
    }
  }
}
