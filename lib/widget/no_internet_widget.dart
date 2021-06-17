import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoInternetWidget extends StatelessWidget {
  BuildContext context;

  NoInternetWidget(this.context);


  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('NO CONNECT'),
          ),
          body: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      "assets/no_connect.png",
                      filterQuality: FilterQuality.high,
                      colorBlendMode: BlendMode.color,
                      width: 150,
                    ),
                  ),
                  Center(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'INTERNET BAĞLANTISINDA HATA OLUŞTU.',
                          textAlign: TextAlign.center,
                        ),
                      ))
                ],
              )));
  }

}