import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
        ),
        body: FutureBuilder<List<Category>>(
          future: fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Card.outlined(
                      elevation: 4.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 90,
                            padding: EdgeInsets.all(12),
                            child: Image.network(
                                "http://91.227.40.169:8080/api/v1/categories/image/${snapshot.data![index].image}",
                                width: 120,
                                height: 90),
                          ),
                          Text(snapshot.data![index].title)
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

Future<List<Category>> fetchCategories() async {
  final response = await http
      .get(Uri.parse('http://91.227.40.169:8080/api/v1/categories/parents'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((data) => Category.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}

class Category {
  final int id;
  final String image;
  final String title;
  final int position;

  Category(
      {required this.id,
      required this.image,
      required this.title,
      required this.position});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      position: json['position'],
    );
  }
}
