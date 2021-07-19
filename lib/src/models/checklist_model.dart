class CheckList {
  String id = "";
  String title = "";
  String description = "";
  List<dynamic> checkpoints = [];

  get getid => this.id;
  set setid(value) => this.id = value;

  get gettitle => this.title;
  set settitle(value) => this.title = value;

  get getdescription => this.description;
  set setdescription(value) => this.description = value;

  get getcheckpoints => this.checkpoints;
  set setcheckpoints(value) => this.checkpoints = value;

  CheckList.fromJSON(Map<String, dynamic> map) {
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
