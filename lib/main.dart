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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      drawer: Drawer(),
      backgroundColor: Color(0xfffdfdfd),
      body: ListView(
        children: <Widget>[
          Dismissible(
            child: _listCard(
                title: "Study Math",
                subtitle: "high",
                color: Colors.deepOrangeAccent),
            key: Key("1"),
          ),
          Dismissible(
            child: _listCard(
                title: "Listen to the Radio",
                subtitle: "medium",
                color: Colors.amber),
            key: Key("2"),
          ),
          Dismissible(
            child: _listCard(
                title: "Take a walk", subtitle: "low", color: Colors.white),
            key: Key("3"),
          ),
        ],
      ),
      floatingActionButton:
          _fab(), // This trailing comma makes auto-formatting nicer for build methods.
    );
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
                onPressed: () {},
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
              FormBuilderValidators.maxLength(4)
            ],
            keyboardType: TextInputType.text,
            initialValue: '',
          ),
          FormBuilderDropdown(
            attribute: "vendor",
            decoration: InputDecoration(
                labelText: "Vendor",
                border: InputBorder.none,
                filled: true,
                fillColor: Color(0xfffdfdfd)),
            hint: Text('Select Priority'),
            validators: [FormBuilderValidators.required()],
            items: ['High', 'Medium', 'Low']
                .map((vendor) =>
                    DropdownMenuItem(value: vendor, child: Text("$vendor")))
                .toList(),
            initialValue: 'High',
          ),
        ],
      ),
    );
  }

  ///Todo list card
  Widget _listCard({String title, String subtitle, Color color}) {
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
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
