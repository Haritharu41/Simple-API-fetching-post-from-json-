import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/post.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "user app",
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<List<Post>> fetchPost() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List<Post> myposts = [];
      var data = jsonDecode(response.body);
      for (Map i in data) {
        myposts.add(Post.fromJson(i as Map<String, dynamic>));
      }
      return myposts;
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User app"),
      ),
      body: FutureBuilder<List<Post>>(
          future: fetchPost(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Mybox(snapshot.data![index]),
                    );
                  });
            }
            return CircularProgressIndicator();
          }),
    );
  }
}

class Mybox extends StatelessWidget {
  final Post p;
  Mybox(this.p);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text("${p.id}"),
      ),
      title: Text("${p.title}"),
      subtitle: Text("${p.body}"),
    );
  }
}
