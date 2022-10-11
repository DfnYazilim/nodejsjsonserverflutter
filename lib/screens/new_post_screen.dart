import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nodejsjsonserverflutter/models/post_model.dart';

class NewPostScreen extends StatefulWidget {
  final PostModel? model;

  const NewPostScreen({Key? key, this.model}) : super(key: key);

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _saveKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _author = TextEditingController();

  @override
  void initState() {
    if (widget.model?.id != null) {
      _title.text = widget.model?.title ?? "";
      _author.text = widget.model?.author ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.model != null ? 'Update Post' : 'New Post'}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _saveKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text("Title")),
                controller: _title,
                validator: (v) {
                  if (v == null || v.length < 2) {
                    return "Title must has 2 characters at least";
                  }
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                decoration: InputDecoration(label: Text("Author")),
                controller: _author,
                validator: (v) {
                  if (v == null || v.length < 2) {
                    return "Author must has 2 characters at least";
                  }
                },
              ),
              SizedBox(
                height: 8,
              ),
              ElevatedButton(
                  onPressed: () async {
                    _saveKey.currentState!.save();
                    if (_saveKey.currentState!.validate()) {
                      if (widget.model == null) {
                        await newPost(PostModel(
                            author: _author.text, title: _title.text));
                      } else {
                        await updatePost(PostModel(
                            author: _author.text, title: _title.text));
                      }
                    }
                  },
                  child: Text(
                      "${widget.model != null ? 'Update Post' : 'New Post'}"))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> newPost(PostModel model) async {
    try {
      var response =
          await Dio().post('http://localhost:3000/posts', data: model.toJson());
      print(response.statusCode);
      if (response.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        print(response.statusCode);
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updatePost(PostModel model) async {
    try {
      var response = await Dio().put(
          'http://localhost:3000/posts/${widget.model?.id??0}' ,
          data: model.toJson());
      print("response.statusCode : ${response.statusCode}");
      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        print(response.statusCode);
        print(response.data);
      }
    } catch (e) {
      print(e);
    }
  }
}
