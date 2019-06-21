import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:yoyo1/bloc.dart' as prefix0;

import './bloc.dart';
import './home_page.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String errorMsg = '';

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  bool wantRegister = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.teal[100],
        ),
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Type email',
                    labelText: 'Email ',
                  ),
                  controller: _emailController,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Pls type something';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Type password',
                    labelText: 'Password ',
                  ),
                  controller: _passController,
                  obscureText: true,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Pls type something';
                    } else {
                      return null;
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    onPressed: _onSubmit,
                    child: Text('Submit'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Sign In'),
                      Switch(
                        inactiveThumbColor: Colors.red,
                        value: wantRegister,
                        onChanged: (val) {
                          setState(() {
                            wantRegister = val;
                          });
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                      Text('Register'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '${errorMsg}',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    final stateK = formKey.currentState;

    if (stateK.validate()) {
      stateK.save();
      if (wantRegister) {
        _register();
      } else {
        _login();
      }
    }
  }

  _register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passController.text);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      authProblems errorType;
      if (Platform.isAndroid) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = authProblems.UserNotFound;
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = authProblems.PasswordNotValid;
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = authProblems.NetworkError;
            break;
          // ...
          default:
            print('Case ${e.message} is not yet implemented');
        }
      } else if (Platform.isIOS) {
        switch (e.code) {
          case 'Error 17011':
            errorType = authProblems.UserNotFound;
            break;
          case 'Error 17009':
            errorType = authProblems.PasswordNotValid;
            break;
          case 'Error 17020':
            errorType = authProblems.NetworkError;
            break;
          // ...
          default:
            print('Case ${e.message} is not jet implemented');
        }
      }

      if (errorType.toString().isNotEmpty || e.message.toString().isNotEmpty) {
        setState(() {
          errorMsg = '${e.message.toString()}';
        });
      } else {
        errorMsg = '';
      }
    }
  }

  void _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passController.text);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      authProblems errorType;
      if (Platform.isAndroid) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = authProblems.UserNotFound;
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = authProblems.PasswordNotValid;
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = authProblems.NetworkError;
            break;
          // ...
          default:
            print('Case ${e.message} is not yet implemented');
        }
      } else if (Platform.isIOS) {
        switch (e.code) {
          case 'Error 17011':
            errorType = authProblems.UserNotFound;
            break;
          case 'Error 17009':
            errorType = authProblems.PasswordNotValid;
            break;
          case 'Error 17020':
            errorType = authProblems.NetworkError;
            break;
          // ...
          default:
            print('Case ${e.message} is not jet implemented');
        }
      }

      if (errorType.toString().isNotEmpty) {
        setState(() {
          errorMsg = '${errorType.toString()}';
          print('${errorType}');
        });
      } else {
        errorMsg = '';
      }
    }
  }
}
