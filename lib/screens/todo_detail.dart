import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_navigation_sqlite/model/todo.dart';
import 'package:flutter_navigation_sqlite/util/dbhelper.dart';
import 'package:intl/intl.dart';

import '../util/dbhelper.dart';
import '../util/dbhelper.dart';

final DbHelper dbHelper = DbHelper();

const menuSave = "Guardar y regresar";
const menuDelete = "Eliminar";
const menuRegresar = "Regresar";

final List<String> _opciones = const <String>[
  menuSave,
  menuDelete,
  menuRegresar,
];

class TodoDetail extends StatefulWidget {
  final Todo todo;

  TodoDetail(this.todo);
  @override
  _TodoDetailState createState() => _TodoDetailState(todo);
}

class _TodoDetailState extends State<TodoDetail> {
  _TodoDetailState(this._todo);
  Todo _todo;
  final _priorities = ["Alta", "Media", "Baja"];
  String _priority = "Baja";
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController descriptionController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = _todo.title;
    descriptionController.text = _todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(_todo.title),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: select,
              itemBuilder: (BuildContext context) {
                return _opciones.map((String opcion) {
                  return PopupMenuItem<String>(
                    value: opcion,
                    child: Text(opcion),
                  );
                }).toList();
              },
            ),
          ],
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
                        onChanged: (String value) => updateTitle(value),
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
                      onChanged: (String value) => updateDescription(value),
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
                    value: retrievePriority(_todo.priority),
                    style: textStyle,
                    onChanged: (String value) {
                      updatePriority(value);
                    },
                  )),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: new Icon(Icons.save),
          onPressed: () => save(),
        ),
    );
    
  }

  void select(String seleccion) async {
    switch (seleccion) {
      case menuSave:
        save();
        break;
      case menuDelete:
        Navigator.pop(context, true);
        if (_todo.id != null) {
          var result = await dbHelper.delete(_todo.id);
          if (result != 0) {
            AlertDialog alert = new AlertDialog(
              title: Text("Eliminado"),
              content: Text("Ha sido eliminado"),
            );

            showDialog(context: context, builder: (_) => alert);
          }
        }
        break;
      case menuRegresar:
        Navigator.pop(context, true);
        break;
    }
  }

  void save() {
    _todo.date = new DateFormat.yMd().format(DateTime.now());
    //Save edit
    if (_todo.id != null) {
      dbHelper.update(_todo);
    } else {
      dbHelper.insert(_todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case "Alta":
        _todo.priority = 1;
        break;
      case "Media":
        _todo.priority = 2;
        break;
      case "Baja":
        _todo.priority = 3;
        break;
      default:
        _todo.priority = 3;
    }

    setState(() {
      _priority = value;
    });
  }

  String retrievePriority(int value){
    try{
      return _priorities[value -1];

    }
    catch(_){
      return _priorities.last;
    }
  }

  void updateTitle(String value){
    _todo.title = titleController.text;
  }

  void updateDescription(String value){
    _todo.description = descriptionController.text;
  }
}
