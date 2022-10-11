import 'package:flutter/material.dart';
import 'package:nodejsjsonserverflutter/screens/comment_list_screen.dart';
import 'package:nodejsjsonserverflutter/screens/post_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON SERVER',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const PostListScreen(),
    );
  }
}

