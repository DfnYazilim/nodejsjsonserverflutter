import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nodejsjsonserverflutter/models/post_model.dart';
import 'package:nodejsjsonserverflutter/screens/new_comment_screen.dart';

import '../models/comment_model.dart';

class CommentListScreen extends StatefulWidget {
  final PostModel postModel;

  const CommentListScreen({Key? key, required this.postModel})
      : super(key: key);

  @override
  _CommentListScreenState createState() => _CommentListScreenState();
}

class _CommentListScreenState extends State<CommentListScreen> {
  List<CommentModel> _clist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: ListView.builder(
          itemBuilder: (context, i) {
            var item = _clist[i];
            return Card(
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text("${item.body ?? ''}"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel")),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      deletFn(item);
                                    },
                                    child: Text("Delete")),
                              ],
                              content: Text(
                                  "Are you sure about to delete this comment?"),
                            ));
                  },
                  child: Icon(Icons.delete),
                ),
                title: Text("${item.body}"),
                trailing: GestureDetector(
                  child: Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewCommentScreen(
                          postId: widget.postModel.id ?? 0,
                          commentModel: item,
                        ),
                      ),
                    ).then((value) {
                      if (value == true) {
                        getHttp();
                      }
                    });
                  },
                ),
              ),
            );
          },
          itemCount: _clist.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          NewCommentScreen(postId: widget.postModel.id ?? 0)))
              .then((value) {
            getHttp();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void getHttp() async {
    try {
      var response = await Dio().get(
          'http://localhost:3000/comments?postId=${widget.postModel.id ?? 0}');
      print(response.data);
      var _datas = <CommentModel>[];
      Iterable _iterable = response.data;
      _datas = _iterable.map((e) => CommentModel.fromJson(e)).toList();
      _clist = _datas;
      setState(() {});
      return;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getHttp();
    super.initState();
  }

  Future<void> deletFn(CommentModel item) async {
    try {
      var response =
          await Dio().delete('http://localhost:3000/comments/${item.id}');
      if (response.statusCode == 200) {
        getHttp();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
}
