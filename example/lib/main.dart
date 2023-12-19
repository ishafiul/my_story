import 'package:share_plus/share_plus.dart';
import 'package:story/new/editor/eidit_story.dart';
import 'package:example/story_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class UserModel {
  UserModel(this.stories, this.userName, this.imageUrl);

  final List<StoryModel> stories;
  final String userName;
  final String imageUrl;
}

class StoryModel {
  StoryModel(this.imageUrl);

  final String imageUrl;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

final GlobalKey globalKey = GlobalKey();

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: RepaintBoundary(
      key: globalKey,
      child: Scaffold(
        body: Column(
          children: [
            Flexible(child: const StoryView()),
          ],
        ),
      ),
    ));
  }
}
