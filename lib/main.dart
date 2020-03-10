import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xffffcef3),
          accentColor: Color(0xffa1eafb),
          fontFamily: "Montserrat"),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///form builder key for todo form
  final GlobalKey<FormBuilderState> _todoFormKey =
      GlobalKey<FormBuilderState>();

  final GlobalKey<FormBuilderState> _todoEditFormKey =
      GlobalKey<FormBuilderState>();

  ///global state key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ///list to hold the todos
  List<Map<String, dynamic>> _todoList = [
//    {'task': 'Learn Flutter', 'priority': 'high'}
  ];

  ///Loading of todo to display
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    //load the todos
    _loadTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      drawer: Drawer(),
      backgroundColor: Color(0xfffdfdfd),
      body: _isLoading ? _loadingView() : _todoBuilder(),
      floatingActionButton:
          _fab(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ///builds the todo list
  Widget _todoBuilder() {
    return _todoList.length == 0
        ? _emptyView()
        : ListView.builder(
            itemCount: _todoList.length,
            itemBuilder: (context, position) {
              return Dismissible(
                onDismissed: (direction) {
                  //remove from list
                  //re-build the state
                  setState(() {
                    _todoList.removeAt(position);
                  });

                  //show message
                  showInSnackBar("Todo deleted successfully.");
                },
                child: _listCard(
                    position: position,
                    title: _todoList[position]['task'],
                    subtitle: _todoList[position]['priority'],
                    color: _getPriorityColor(_todoList[position]['priority'])),
                key: Key("$position"),
              );
            });
  }

  ///Gets priority color
  Color _getPriorityColor(String priority) {
    //set high priority color as default
    Color color = Colors.deepOrangeAccent;
    if (priority.toLowerCase() == 'medium') {
      color = Colors.amber;
    } else if (priority.toLowerCase() == 'low') {
      color = Colors.white;
    }

    return color;
  }

  ///App Bar
  Widget _appBar() {
    return AppBar(
      title: Text(
        "Todo",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
      ),
      centerTitle: true,
      elevation: 0.0,
      brightness: Brightness.light,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        IconButton(
          icon: Icon(LineIcons.search),
          onPressed: () {},
        )
      ],
    );
  }

  ///Floating action button
  Widget _fab() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: _addToDoDialog,
      tooltip: 'Add',
      child: Icon(
        LineIcons.plus,
        color: Colors.black,
      ),
    );
  }

  ///Todo list card
  Widget _listCard({String title, String subtitle, Color color, int position}) {
    return Card(
      color: Color(0xff278ea5),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: color, width: 5.0)),
        ),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CircleAvatar(
              radius: 8.0,
              backgroundColor: color,
            ),
          ),
          title: Text(
            "$title",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "$subtitle",
            style: TextStyle(color: Color(0xfffdfdfd)),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editToDoDialog(position);
            },
          ),
        ),
      ),
    );
  }

  ///Empty View
  Widget _emptyView() {
    return Center(child: Image.asset("images/empty_list.png"));
  }

  ///Loading View
  Widget _loadingView() {
    return Center(
        child: SpinKitFoldingCube(
      color: Theme.of(context).accentColor,
      size: 45.0,
    ));
  }

  ///Dialog box to edit to do
  Future<Widget> _editToDoDialog(int position) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 4.0,
            title: Text(
              "Update Todo",
            ),
            content: _editForm(position),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  "Update",
                ),
                onPressed: () {
                  _editTodo(position);
                },
              )
            ],
          );
        });
  }

  ///Form for editing todo
  Widget _editForm(int position) {
    //get the task and priority
    String task = _todoList[position]['task'];
    String priority = _todoList[position]['priority'];

    return FormBuilder(
      key: _todoEditFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FormBuilderTextField(
            attribute: "task",
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Task",
                labelStyle: TextStyle(fontSize: 12.0),
                border: InputBorder.none,
                filled: true,
                fillColor: Color(0xfffdfdfd)),
            validators: [
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(4)
            ],
            keyboardType: TextInputType.text,
            initialValue: '$task',
          ),
          FormBuilderDropdown(
            attribute: "priority",
            decoration: InputDecoration(
                labelText: "Prriority",
                border: InputBorder.none,
                filled: true,
                fillColor: Color(0xfffdfdfd)),
            hint: Text('Select Priority'),
            validators: [FormBuilderValidators.required()],
            items: ['High', 'Medium', 'Low']
                .map((priority) =>
                    DropdownMenuItem(value: priority, child: Text("$priority")))
                .toList(),
            initialValue: '$priority',
          ),
        ],
      ),
    );
  }

  ///Dialog box to add to do
  Future<Widget> _addToDoDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 4.0,
            title: Text(
              "Add Todo",
            ),
            content: _todoForm(),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Cancel",
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  "Add",
                ),
                onPressed: _addTodo,
              )
            ],
          );
        });
  }

  ///Form for adding todo
  Widget _todoForm() {
    return FormBuilder(
      key: _todoFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FormBuilderTextField(
            attribute: "task",
            autofocus: true,
            decoration: InputDecoration(
                labelText: "Task",
                labelStyle: TextStyle(fontSize: 12.0),
                border: InputBorder.none,
                filled: true,
                fillColor: Color(0xfffdfdfd)),
            validators: [
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(4)
            ],
            keyboardType: TextInputType.text,
            initialValue: '',
          ),
          FormBuilderDropdown(
            attribute: "priority",
            decoration: InputDecoration(
                labelText: "Priority",
                border: InputBorder.none,
                filled: true,
                fillColor: Color(0xfffdfdfd)),
            hint: Text('Select Priority'),
            validators: [FormBuilderValidators.required()],
            items: ['High', 'Medium', 'Low']
                .map((priority) =>
                    DropdownMenuItem(value: priority, child: Text("$priority")))
                .toList(),
            initialValue: 'High',
          ),
        ],
      ),
    );
  }

  //adds to do to the list
  void _addTodo() {
    //if validation is successful, update the quantity on the product
    if (_todoFormKey.currentState.saveAndValidate()) {
      //get the task
      String task = _todoFormKey.currentState.value['task'];
      //get the priority
      String priority = _todoFormKey.currentState.value['priority'];
      //create a map
      Map<String, dynamic> todo = {'task': task, 'priority': priority};

      //add to the list
      setState(() {
        _todoList.add(todo);
      });

      //close the dialog
      Navigator.pop(context);
      //show message
      showInSnackBar("Todo added successfully.");
    }
  }

  //edits to do to the list
  void _editTodo(int position) {
    //if validation is successful, update the quantity on the product
    if (_todoEditFormKey.currentState.saveAndValidate()) {
      //get the task
      String task = _todoEditFormKey.currentState.value['task'];
      //get the priority
      String priority = _todoEditFormKey.currentState.value['priority'];
      //create a map
      Map<String, dynamic> todo = {'task': task, 'priority': priority};

      //remove the old todo
      _todoList.removeAt(position);

      //add to the list to update it
      setState(() {
        _todoList.insert(position, todo);
      });

      //close the dialog
      Navigator.pop(context);
      //show message
      showInSnackBar("Todo updated successfully.");
    }
  }

  ///Delay for some seconds and show the todo
  void _loadTodo() async {
    //set is loading to true
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  ///Shows message in [Snack Bar]
  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}
