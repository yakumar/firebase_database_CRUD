import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:yoyo1/home_page.dart';

import 'bloc.dart';
import './login_page.dart';

void main() => runApp(MyApp());
final firebaseDatabaseRef = FirebaseDatabase.instance.reference();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context){
          return LoginPage();
          

        },
        "/home":(context)=>MyHomePage(),
      },
    );
  }
}
