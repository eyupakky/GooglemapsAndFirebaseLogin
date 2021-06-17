import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:evreka_technical_question/widget/no_internet_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class BasePage extends StatefulWidget {
  BasePage({Key key}) : super(key: key);
}

abstract class BaseState<Page extends BasePage> extends State<Page> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  checkInternetConnection();
}

mixin BasicPage<Page extends BasePage> on BaseState<Page> {
  bool connectionExist = false;

  @override
  void initState() {
    super.initState();
    checkConnectionIssues();
  }

  var connectionListener;

  checkConnectionIssues() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        connectionExist = true;
      });
    }
    connectionListener = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          connectionExist = false;
        });
      } else
        setState(() {
          connectionExist = true;
        });
    });
  }
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        } else
          return false;
      } on SocketException catch (_) {
        return false;
      }
    } else
      return false;
  }

  @override
  void setState(fn) {
    if (this.mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (connectionExist) {
      checkInternetConnection();
      return body();
    } else {
      return NoInternetWidget(context);
    }
  }

  Widget body();
}
