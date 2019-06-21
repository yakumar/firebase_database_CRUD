import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

import './bloc.dart';


final firebaseDatabaseRef = FirebaseDatabase.instance.reference();


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textController = TextEditingController();
  List<Event> lister = [];
  FirebaseUser newU;
  DatabaseReference childRef =
      firebaseDatabaseRef.child('messages').child('new');


  Future<String> currentUser()async{
    newU = await FirebaseAuth.instance.currentUser();
    return newU.email;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // childRef.once().then((DataSnapshot snapshot){
    //   print(snapshot.value);
    // });

    currentUser();
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
        leading: Text('${newU.email}'),
        actions: <Widget>[
          Text('Sign Out'),
          IconButton(

            icon: Icon(Icons.all_out),
            onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
        ],
        
      ),
      
        

              body: Container(
          alignment: Alignment.topCenter,
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              
              Container(
                margin: EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'press enter',
                      labelText: 'Type & Enter.. ',
                    ),
                  controller: _textController,
                  onSubmitted: (val) => _onSubmitted(val),
                ),
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
                                onTap: () => _onEdit(context, todoListy[index]),
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
      
      
    );
  }

  _onEdit(BuildContext context, Todo todoListy) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController _editTitleController =
              TextEditingController(text: todoListy.title);

          return SimpleDialog(
            title: Text('Editing ..'),
            contentPadding: EdgeInsets.all(10.0),
            backgroundColor: Colors.orange,
            children: <Widget>[
              TextField(
                controller: _editTitleController,
                onChanged: (val) {},
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          firebaseDatabaseRef
                              .child("/messages/")
                              .child('/new/' + todoListy.id)
                              .update({
                            'title': _editTitleController.text,
                            'time': '${DateTime.now()}'
                          });

                          Navigator.of(context).pop();
                        },
                        child: Text('Submit'),
                      ),
                      Container(
                        width: 7.0,
                      ),
                      RaisedButton(
                        onPressed: () {
                          firebaseDatabaseRef
                              .child("/messages/")
                              .child('/new/' + todoListy.id)
                              .remove();
                          Navigator.of(context).pop();
                        },
                        child: Text('Delete'),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
