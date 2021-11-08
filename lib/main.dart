import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SQLite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Database database;
  List<Map<String, Object?>> todoData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDatabase();
  }

  Future<String> getDatabasePath() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath(); // just path
    String path = join(databasesPath, 'todo.db'); //`join` function from the
    // `path` package is best practice to ensure the path is correctly

    return path;
  }

  void createDatabase() async {
    // open the database
    String path = await getDatabasePath();
    database = await openDatabase (path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Test (id INTEGER PRIMARY KEY, title TEXT, finish INTEGER)');
    });
    readData();
  }

  void insertData() async {
    int recordId = await database.insert('Test', {'title': 'Go home', 'finish': 0});
  }

  void readData() async {
    var list = await database.query('Test', columns: ['title', 'finish']);
    todoData = list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
          return ListTile(
            title: Text(todoData[index]['title'].toString()),
          );
        },
        itemCount: todoData.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //insertData();
          readData();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
