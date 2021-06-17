import 'dart:async';

import 'package:evreka_technical_question/widget/base_widget.dart';
import 'package:evreka_technical_question/locator.dart';
import 'package:evreka_technical_question/services/app_context.dart';
import 'package:evreka_technical_question/services/authentication_service.dart';
import 'package:evreka_technical_question/util/helper.dart';
import 'package:evreka_technical_question/widget/my_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class LoginPage extends BasePage {
  LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage> with BasicPage {
  bool _isLoading = false;
  String errorMessage = "";
  bool forgatMyPassword = false;
  final _formKey = GlobalKey<FormState>();
  Widget userImage;
  Widget passImage;

  BaseContext get nduContext => ContextProvider.of(context).current;
  final AuthenticationService _auth = AuthenticationService();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    userImage = Icon(
      Icons.account_circle_rounded,
      color: Colors.grey,
    );
    passImage = Icon(
      Icons.remove_red_eye,
      color: Colors.grey,
    );
    _auth.getUserLogin().then((value) {
      if (value != null && value) {
        _auth.getUserData().then((value) => goTo(value));
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget body() {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * .2),
                  _title(),
                  SizedBox(height: 60),
                  formSection(),
                  SizedBox(height: 20),
                  _submitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  bool checkInternetConnection() {
    return false;
  }

  void goTo(String authUser) {
    nduContext.setCurrentUser(authUser);
    _isLoading = false;
    Navigator.pushReplacementNamed(context, '/map');
  }

  signIn(String email, pass) async {
    _auth.signInWithEmailAndPassword(email, pass).then((authUser) {
      if (authUser == 'weak-password') {
        passValidate = true;
        showToast('The password provided is too weak.');
        passwordValidateMethod();
        _isLoading = false;
      } else if (authUser == 'email-already-in-use' || authUser == 'user-not-found') {
        showToast('The account already exists for that email.');
        userValidate = true;
        userValidateMethod();
        _isLoading = false;
      } else {
        goTo(authUser);
      }
      setState(() {});
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      String message = "Hata oluştu.";
      if (error != null) message = error.toString();
      showToast(message);
    });
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool userValidate = false, passValidate = false;
  bool invisible = true;
  Color eyeColor = Colors.grey;

  Widget formSection() {
    emailController.text = "eyup@evreka.com";
    passwordController.text = "123456";
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: <Widget>[
            Theme(
              data: new ThemeData(
                  primaryColor: userValidate ? Colors.red : Color.fromRGBO(233, 207, 48, 1),
                  accentColor: userValidate ? Colors.red : Color.fromARGB(1, 233, 207, 48),
                  hintColor: Colors.deepPurpleAccent),
              child: TextFormField(
                controller: emailController,
                onChanged: (val) {
                  if (val == null || val.isEmpty || val.length < 3) {
                    userValidate = true;
                  } else {
                    userValidate = false;
                  }
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    child: userImage,
                  ),
                  labelText: "Username",
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: userValidate ? Colors.red : Colors.grey)),
                  labelStyle: TextStyle(color: userValidate ? Colors.red : Color.fromRGBO(83, 90, 114, 1)),
                ),
              ),
            ),
            Theme(
              data: new ThemeData(
                  primaryColor: passValidate ? Colors.red : Color.fromRGBO(233, 207, 48, 1),
                  accentColor: Color.fromARGB(1, 233, 207, 48),
                  hintColor: Colors.deepPurpleAccent),
              child: TextFormField(
                controller: passwordController,
                obscureText: invisible,
                onChanged: (val) {
                  if (val == null || val.isEmpty || val.length < 6) {
                    passValidate = true;
                  } else {
                    passValidate = false;
                  }
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTapDown: inPassword,
                    onTapUp: outPassword,
                    child: passImage,
                  ),
                  labelText: "Password",
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: userValidate ? Colors.red : Colors.grey)),
                  labelStyle: TextStyle(color: passValidate ? Colors.red : Color.fromRGBO(83, 90, 114, 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void inPassword(TapDownDetails details) {
    setState(() {
      invisible = false;
      eyeColor = Color.fromRGBO(233, 207, 48, 1);
    });
  }

  void outPassword(TapUpDetails details) {
    setState(() {
      invisible = true;
      eyeColor = Colors.grey;
    });
  }

  void userValidateMethod() {
    if (userValidate || emailController.text == "") {
      userImage = Icon(
        Icons.error,
        color: Colors.red,
      );
      userValidate = true;
      showToast('There is no such username!');
    } else {
      userValidate = false;
      userImage = Icon(
        Icons.account_circle_rounded,
        color: Colors.grey,
      );
    }
  }

  void passwordValidateMethod() {
    if (passValidate || passwordController.text == "") {
      passValidate = true;
      passImage = Icon(
        Icons.error,
        color: Colors.red,
      );
      showToast('There is no such password!');
    } else {
      passValidate = false;
      passImage = Icon(
        Icons.remove_red_eye,
        color: Colors.grey,
      );
    }
  }

  Widget _submitButton() {
    return _isLoading
        ? MyProgress(
            type: "linear",
          )
        : InkWell(
            onTap: () {
              userValidateMethod();
              passwordValidateMethod();
              setState(() {});
              if (!userValidate && !passValidate) {
                setState(() {
                  _isLoading = true;
                });
                signIn(emailController.text, passwordController.text);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Color.fromRGBO(69, 155, 35, 1),
              ),
              child: Text(
                'LOGIN',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
  }

  Widget _title() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 79),
          width: MediaQuery.of(context).size.width / 2.5,
          child: Image.asset(
            "assets/logo.png",
          ),
        ),
        Text("Please enter your user name and password. (T2)", style: TextStyle(fontSize: 27, color: Color.fromRGBO(83, 90, 114, 1)))
      ],
    );
  }
}
