import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_navigation_sqlite/model/todo.dart';

class DbHelper{
  static final DbHelper _dbHelper = new DbHelper._internal();

  String tblTodo = "todo";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";

  DbHelper._internal();

  factory DbHelper(){
    return _dbHelper; 
  }

  Future<Database> initializeDb() async{
    Directory dir = await getApplicationDocumentsDirectory();

    String path = dir.path + "todos.db";
    // var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);
    // return dbTodos;
    return openDatabase(path, version: 2, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      '''CREATE TABLE $tblTodo(
        $colId INTEGER PRIMARY KEY, 
        $colTitle TEXT,
        $colDescription TEXT,
        $colPriority INTEGER,
        $colDate TEXT
        )'''
      //"CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTitle TEXT,$colDescription TEXT,$colPriority TEXT,$colDate TEXT)"
    );
  }

  static Database _db;

  Future<Database> get db async{
    if(_db == null){
      _db = await initializeDb();
    }
    return _db;
  }

  Future<int> insert(Todo todo) async{
    var db = await this.db;
    var result = await db.insert(tblTodo,todo.toMap());
    return result;
  }

  Future<List> getTodos() async{
    var db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblTodo ORDER BY $colPriority ASC");

    return result;
  }

  Future<int> getCount() async{
    var db = await this.db;

    var result = Sqflite.firstIntValue(
      await db.rawQuery("SELECT count(*) FROM $tblTodo")
    );
    return result;
  }

  Future<int> update(Todo todo) async {
    var db = await this.db;
    var result = await db.update(tblTodo, todo.toMap(), where: "$colId = ?", whereArgs: [todo.id] );

    return result;
  }

  Future<int> delete(int id) async {
    var db = await this.db;

    var result = await db.delete(tblTodo, where: "$colId = ?",whereArgs: [id]);

    return result;
  }
}
