/// id : 1
/// body : "some comment"
/// postId : 1

class CommentModel {
  CommentModel({
      this.id, 
      this.body, 
      this.postId,});

  CommentModel.fromJson(dynamic json) {
    id = json['id'];
    body = json['body'];
    postId = json['postId'];
  }
  num? id;
  String? body;
  num? postId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['body'] = body;
    map['postId'] = postId;
    return map;
  }

}