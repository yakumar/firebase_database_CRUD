import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Todo {
  String time;
  String title;
  String id;

  Todo({this.title, this.time, this.id});
  Todo.fromJson(DataSnapshot snapshot){
    time= snapshot.value['time'];
    title = snapshot.value['title'];

  }
    
  factory Todo.to(){
    return Todo(
      time: '',
      title: ''
    );
  }  

  

  
}


final firebaseDatabaseRef = FirebaseDatabase.instance.reference();
    DatabaseReference childRef = firebaseDatabaseRef.child('messages').child('new');





class NewBloc {

  List<Todo> todoList = [];

  ReplaySubject behaviorSubject = ReplaySubject();
  
  
  StreamController streamController = StreamController<Map<String, String>>.broadcast();
    StreamController listStreamController = StreamController<List<Todo>>();


  get newSink => streamController.sink;

  get newStream => streamController.stream;

  Stream<Event> get myStream => childRef.onChildAdded;

//   get obsStream => behaviorSubject
  

  void getData()async{

    Stream hola = await childRef.onChildAdded;
    
    //todoList.add(Todo.fromJson(hola));

    listStreamController.sink.add(todoList);
    




    DataSnapshot newD = await childRef.once();



    

    newSink.add(newD.value);

    

  }

  void onNew(){
    childRef.once().then((data){
      
      todoList.add(Todo.fromJson(data));
      behaviorSubject.sink.add(todoList);
      

    });
    
  }


void dispose(){
  streamController.close();
  listStreamController.close();
  behaviorSubject.close();
}



}

final bloc = NewBloc();