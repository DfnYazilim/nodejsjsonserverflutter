import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nodejsjsonserverflutter/models/comment_model.dart';

class NewCommentScreen extends StatefulWidget {
  final CommentModel? commentModel;
  final num postId;

  const NewCommentScreen({Key? key, required this.postId,  this.commentModel}) : super(key: key);

  @override
  _NewCommentScreenState createState() => _NewCommentScreenState();
}

class _NewCommentScreenState extends State<NewCommentScreen> {
  TextEditingController _body = TextEditingController();
  final _saveKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.commentModel == null? 'New Comment' : 'Update Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _saveKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(label: Text("Your Comment")),
                  controller: _body,
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                    onPressed: () {
                      _saveKey.currentState!.save();
                      if (_saveKey.currentState!.validate()) {
                        if(widget.commentModel==null){
                          newComment(CommentModel(body: _body.text,postId: widget.postId));
                        } else {
                          updateComment(CommentModel(body: _body.text,postId: widget.postId,id: widget.commentModel?.id??0));
                        }
                      }
                    },
                    child: Text(widget.commentModel == null ? " Save new comment" : "Update comment"))
              ],
            )),
      ),
    );
  }
  void newComment(CommentModel commentModel) async {
    try {
      var response = await Dio().post('http://localhost:3000/comments',data: commentModel.toJson());
      if(response.statusCode == 201){
        Navigator.pop(context,true);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
  void updateComment(CommentModel commentModel) async {
    try {
      var response = await Dio().put('http://localhost:3000/comments/${commentModel.id}',data: commentModel.toJson());
      if(response.statusCode == 200){
        Navigator.pop(context,true);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    if(widget.commentModel != null){
      _body.text = widget.commentModel?.body ?? "";
    }
    super.initState();
  }
}
