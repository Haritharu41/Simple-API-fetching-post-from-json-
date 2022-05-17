import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/User.dart';
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

  Future<List<User>> fetchUser() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      List<User> users = [];
      var data = jsonDecode(response.body);
      for (Map i in data) {
        users.add(User.fromJson(i as Map<String, dynamic>));
      }
      return users;
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
      body: FutureBuilder<List<User>>(
          future: fetchUser(),
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
  final User p;
  Mybox(this.p);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Text(
          "Id:" + p.id.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          "Name:" + p.name.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
            "Address:${p.address!.street.toString()} ,${p.address!.zipcode.toString()}"),
        Text("Company:" + p.company!.name.toString())
      ]),
    );
  }
}
