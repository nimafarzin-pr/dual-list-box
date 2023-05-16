import 'package:flutter/material.dart';

import 'double_searchlist.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Double search list',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Double search list'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DoubleSrearchList(
                // optional key for value which you want to show
                valueKey: 'name',
                onActions: (selectedData) {
                  print(selectedData);
                },
                data: const [
                  {"id": '1', "name": "name1"},
                  {"id": '2', "name": "name2"},
                  {"id": '3', "name": "name3"},
                  {"id": '4', "name": "name4"},
                  {"id": '5', "name": "name5"},
                  {"id": '6', "name": "name6"},
                  {"id": '7', "name": "name7"},
                  {"id": '8', "name": "name8"},
                  {"id": '9', "name": "name9"},
                  {"id": '10', "name": "name10"},
                  {"id": '11', "name": "name11"},
                  {"id": '12', "name": "name12"},
                  {"id": '13', "name": "name13"},
                  {"id": '14', "name": "name14"},
                  {"id": '15', "name": "name15"},
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
