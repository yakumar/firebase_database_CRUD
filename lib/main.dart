import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'bloc.dart';

void main() => runApp(MyApp());
final firebaseDatabaseRef = FirebaseDatabase.instance.reference();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textController = TextEditingController();
  List<Event> lister = [];
  DatabaseReference childRef =
      firebaseDatabaseRef.child('messages').child('new');

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // childRef.once().then((DataSnapshot snapshot){
    //   print(snapshot.value);
    // });
  }

  _onSubmitted(String val) {
    print(val);
    setState(() {
      childRef.push().set({"title": val, "time": '${DateTime.now()}'});
      bloc.onNew();
      _textController.text = "";
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(bloc.newStream.value);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            TextField(
              controller: _textController,
              onSubmitted: (val) => _onSubmitted(val),
            ),
            StreamBuilder(
                stream: childRef.orderByValue().onValue,
                builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasData) {
                    List<Todo> todoListy = [];

                    DataSnapshot qq = snapshot.data.snapshot;
                    if (qq.value != null) {
                      Map<dynamic, dynamic> newMap = Map.from(qq.value);

                      newMap.forEach((k, v) {
                        //   Todo todo = Todo(id: k, title: v['title'], time: v['time']);

                        todoListy.add(
                            Todo(id: k, title: v['title'], time: v['time']));
                      });
                      //  print(todoListy[1].title);
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: todoListy.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text('${todoListy[index].title}'),
                              subtitle: Text('${todoListy[index].time}'),
                              onTap: ()=>_onEdit(context, todoListy[index]),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                } else {
                                                  return Container();
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                    floatingActionButton: FloatingActionButton(
                                      onPressed: _incrementCounter,
                                      tooltip: 'Increment',
                                      child: Icon(Icons.add),
                                    ), // This trailing comma makes auto-formatting nicer for build methods.
                                  );
                                }
                              
 _onEdit(BuildContext context, Todo todoListy) {
   showDialog(
     context: context,
     


     builder: (BuildContext context){
       TextEditingController _editTitleController = TextEditingController(text: todoListy.title);

       return SimpleDialog(
         title: Text('Editing ..'),
         contentPadding: EdgeInsets.all(10.0),
         backgroundColor: Colors.orange,
         children: <Widget>[
           TextField(controller: _editTitleController,
           
                onChanged: (val) {},
                textAlign: TextAlign.center,),
              

                Padding(padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      RaisedButton(onPressed: () {
                        
                        firebaseDatabaseRef.child("/messages/").child('/new/'+todoListy.id).update({'title':_editTitleController.text, 'time': '${DateTime.now()}'});


                        Navigator.of(context).pop();
                      }, child: Text('Submit'),),
                      Container(width: 7.0,),
                      RaisedButton(onPressed: (){firebaseDatabaseRef.child("/messages/").child('/new/'+todoListy.id).remove();
                      Navigator.of(context).pop();
                      }, child: Text('Delete'), color: Colors.red,),
                    ],

                  ),
                ),
              ),

         ],

       );
     }
   );
 }
}
