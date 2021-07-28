class CheckList {
  String id = "";
  String title = "";
  String description = "";
  List<dynamic> checkpoints = [];

  CheckList({
    this.id = "",
    this.title = "",
    this.description = "",
    this.checkpoints = const [],
  });

  Map toMap(CheckList checkList) {
    var data = Map<String, dynamic>();
    data['id'] = checkList.id;
    data['title'] = checkList.title;
    data['description'] = checkList.description;
    data["checkpoints"] = checkList.checkpoints;

    return data;
  }

  CheckList.fromMap(Map<String, dynamic> map) {
    try {
      this.id = map["id"];
      this.title = map["title"];
      this.description = map["description"];
      this.checkpoints = map["checkpoints"];
    } catch (err) {
      print("Error in parsing JSON to Checklist Object: " + err.toString());
    }
  }
}
