import 'dart:convert';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  // Parse The JSON dictionary
  Map dictionary;
  bool loadingDictionary = true;
  void getDictionaryJSON() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/dictionary_alpha_arrays.json");
    List jsonResult = json.decode(data);
    print("started");
    dictionary = jsonResult[0];
    for (int i = 1; i < jsonResult.length; i++) {
      dictionary.addAll(jsonResult[i]);
    }
    print("done");
    //dictionary = jsonResult[0];
    loadingDictionary = false;
    Navigator.pushReplacementNamed(context, "home",
        arguments: {"dictionary": dictionary});
  }

  @override
  void initState() {
    super.initState();
    getDictionaryJSON();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff292826),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Spacer(),
              Image.asset("assets/icon.jpg"),
              SizedBox(height: 50.0),
              Text(
                "Lexicon".toUpperCase(),
                style: TextStyle(
                  color: Colors.grey[200],
                ),
              ),
              Spacer(),
              Spacer(),
              Text(
                "Made with 🤎 by Dream Intelligence".toLowerCase(),
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey[200],
                ),
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
