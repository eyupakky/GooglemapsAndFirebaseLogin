import 'dart:async';
import 'package:evreka_technical_question/model/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ContextProvider<T extends ChangeNotifier> extends InheritedWidget {
  final BaseContext current;

  const ContextProvider({Key key, Widget child, this.current}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ContextProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ContextProvider>();
  }
}

abstract class BaseContext {

  String get currentUser;

  void setCurrentUser(String currentUser);



}

class AppContext implements BaseContext {
  String _currentUser;
  bool menuRefresh = false;

  AppContext();

  @override
  String get currentUser => _currentUser;


  @override
  void setCurrentUser(String currentUser) {
    this._currentUser = currentUser;
  }

}
