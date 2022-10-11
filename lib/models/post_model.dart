/// id : 1
/// title : "json-server"
/// author : "typicode"

class PostModel {
  PostModel({
      this.id, 
      this.commentCount,
      this.title,
      this.author,});

  PostModel.fromJson(dynamic json) {
    id = json['id'];
    commentCount = 0;
    title = json['title'];
    author = json['author'];

  }
  num? id;
  num? commentCount;
  String? title;
  String? author;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['author'] = author;
    return map;
  }

}