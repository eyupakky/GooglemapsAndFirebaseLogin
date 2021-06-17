import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evreka_technical_question/page/login_page.dart';
import 'package:evreka_technical_question/page/map_page.dart';
import 'package:evreka_technical_question/services/app_context.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
bool USE_FIRESTORE_EMULATOR = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }
  AppContext nduContext = new AppContext();
  runApp(ContextProvider(
    current: nduContext,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => LoginPage(),
        "/map": (context) => MapPage(),
      },
      title: 'test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

