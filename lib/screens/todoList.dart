import 'package:flutter/material.dart';

import 'package:flutter_navigation_sqlite/model/todo.dart';
import 'package:flutter_navigation_sqlite/screens/todo_detail.dart';
import 'package:flutter_navigation_sqlite/util/dbhelper.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  DbHelper _helper = new DbHelper();
  List<Todo> _todoList;
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    if (_todoList == null || _todoList.length <= 0) {
      _todoList = new List<Todo>();
      getData();
    }
    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToDetail(Todo("",3,"")),
        tooltip: "Add todo",
        child: new Icon(Icons.add),
      ),
    );
  }

  ListView todoListItems() {
    return ListView.builder(
      itemCount: _todoList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColor(this._todoList[index].priority),
              child: Text(this._todoList[index].id.toString()),
            ),
            title: Text(this._todoList[index].title.toString()),
            subtitle: Text(this._todoList[index].date.toString()),
            onTap: () {
              debugPrint(this._todoList[index].id.toString());
              navigateToDetail(this._todoList[index]);
            },
          ),
        );
      },
    );
  }

  void getData() async {
    await _helper.initializeDb();

    var todos = await _helper.getTodos();
    List<Todo> todoList = new List<Todo>();
    _count = todos.length;

    if (_count <= 0) {
      _seedData();
    }

    for (int i = 0; i < _count; i++) {
      var aux = Todo.fromObject(todos[i]);
      todoList.add(aux);
      debugPrint(aux.title);
    }
    setState(() {
      this._todoList = todoList;
      this._count = _count;
    });
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;
      default:
        return Colors.green;
        break;
    }
  }

  void _seedData() async {
    var now = new DateTime.now();
    List<Todo> toInserList = <Todo>[
      new Todo("Apple", 1, now.toString(), "Check all are goods"),
      new Todo("Orange", 2, now.toString(), "Check all are goods"),
    ];

    for (final todo in toInserList) {
      var index = await _helper.insert(todo);
      //debugPrint("Inserted " + todo.title);
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoDetail(todo)));
    if (result ?? false) {
      getData();
    }
  }
}
