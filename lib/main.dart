import 'package:dictionary/homePage.dart';
import 'package:dictionary/loadingPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Dictionary());
}

class Dictionary extends StatefulWidget {
  @override
  _DictionaryState createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: Colors.grey[900],
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => LoadingPage(),
        "home": (context) => HomePage(),
      },
    );
  }
}
