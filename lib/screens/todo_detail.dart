import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_navigation_sqlite/model/todo.dart';
import 'package:flutter_navigation_sqlite/util/dbhelper.dart';
import 'package:intl/intl.dart';

class TodoDetail extends StatefulWidget {
  final Todo todo;

  TodoDetail(this.todo);
  @override
  _TodoDetailState createState() => _TodoDetailState(todo);
}

class _TodoDetailState extends State<TodoDetail> {
  _TodoDetailState(this.todo);
  Todo todo;
  final _priorities = ["Alta", "Media", "Baja"];
  String _priority = "Baja";
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(todo.title),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 10, right: 10),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    style: textStyle,
                    decoration: InputDecoration(
                        labelStyle: textStyle,
                        labelText: "Titulo",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: descriptionController,
                      style: textStyle,
                      decoration: InputDecoration(
                          labelStyle: textStyle,
                          labelText: "Descripcion",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                    ),
                  ),
                  ListTile(
                      title: DropdownButton<String>(
                    items: _priorities.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: _priority,
                    style: textStyle,
                    onChanged: (String value) {
                      return;
                    },
                  )),
                ],
              ),
            ],
          ),
        ));
  }
}
