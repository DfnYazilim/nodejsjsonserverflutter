import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nodejsjsonserverflutter/models/comment_model.dart';
import 'package:nodejsjsonserverflutter/screens/comment_list_screen.dart';
import 'package:nodejsjsonserverflutter/screens/new_post_screen.dart';

import '../models/post_model.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  List<PostModel> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemBuilder: (context, i) {
              var item = _list[i];
              return Card(
                child: ListTile(
                  title: Text("${item.title}"),
                  subtitle: Text("${item.author}"),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: Icon(Icons.delete),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(item.title ?? ""),
                              content:
                                  Text("Are you sure about to delete this item"),
                              actions: [
                                ElevatedButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: Text("Cancel")),
                                ElevatedButton(onPressed: (){
                                  deletePost(item.id ?? 0);
                                  Navigator.pop(context);

                                }, child: Text("Delete")),
                              ],
                            ),
                          );
                        },
                      ),
                      Text("${item.commentCount}")
                    ],
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> CommentListScreen(postModel: item,))).then((value) {
                      getHttp();
                    });
                  },
                  trailing: GestureDetector(
                    child: Icon(Icons.edit),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => NewPostScreen(
                                    model: item,
                                  ))).then((value) {
                        if (value == true) {
                          getHttp();
                        }
                      });
                    },
                  ),
                ),
              );
            },
            itemCount: _list.length),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                    context, MaterialPageRoute(builder: (_) => NewPostScreen()))
                .then((value) {
              if (value == true) {
                getHttp();
              }
            });
          },
          child: Icon(Icons.add)),
    );
  }

  void getHttp() async {
    try {
      var response = await Dio().get('http://localhost:3000/posts');
      var _datas = <PostModel>[];
      Iterable _iterable = response.data;
      _datas = _iterable.map((e) => PostModel.fromJson(e)).toList();
      _list = _datas;
      final comments = await getCommentCountsV2();
      print('comments l : ${comments.length}');
      for (var element in _list) {
        element.commentCount = comments.where((comment) => comment.postId == element.id).length;
      }
      // for (var element in _list) {
      //   final count = await getCommentCountsV1(element.id??0);
      //   element.commentCount = count;
      // }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
  void deletePost(num id) async {
    try {
      var response = await Dio().delete('http://localhost:3000/posts/$id');
      print(response.statusCode);
      if(response.statusCode == 200){
        getHttp();
      } else {
        print(response.statusCode);
      }
      // var _datas = <PostModel>[];
      // Iterable _iterable = response.data;
      // _datas = _iterable.map((e) => PostModel.fromJson(e)).toList();
      // _list = _datas;
      // setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getHttp();
    super.initState();
  }
  Future<int> getCommentCountsV1(num postId) async {
    try {
      print('-----');
      var response = await Dio().get('http://localhost:3000/comments?postId=$postId');
      if(response.statusCode == 200){
        var _datas = <CommentModel>[];
        Iterable _iterable = response.data;
        _datas = _iterable.map((e) => CommentModel.fromJson(e)).toList();

        return _datas.length;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }
  Future<List<CommentModel>> getCommentCountsV2() async {
    try {
      var response = await Dio().get('http://localhost:3000/comments');
      if(response.statusCode == 200){
        var _datas = <CommentModel>[];
        Iterable _iterable = response.data;
        _datas = _iterable.map((e) => CommentModel.fromJson(e)).toList();

        return _datas;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
