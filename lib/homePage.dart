import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map dictionary;
  bool showMeaningCard = false;
  bool enableSuggestions = true;
  bool searchByBeginning = true;
  TextEditingController searchedWord = TextEditingController();

  // Function for searching meanings of words given
  String meaning = " ";
  String searchedTerm = " ";
  void searchForMeaning(searchedTermInput) {
    // Clear out suggestions
    suggestionsList = [];
    suggestionCount = 0;
    // Look up meaning of word
    searchedTerm = searchedTermInput;
    meaning = dictionary[searchedTerm];
    // Handle errors
    if (searchedTerm == "") {
      searchedTerm = "Empty Search";
      meaning = "Please type a word to search for it's meaning!";
    }
    if (meaning == null) {
      meaning = "Was not found!";
    }
    // Show the meaning
    showMeaningCard = true;
    setState(() {});
  }

  // Function to suggest for words
  int suggestionCount = 0;
  List suggestionsList = [];
  void suggestions(String word) {
    suggestionCount = 0;
    suggestionsList = [];
    showMeaningCard = false;
    if (enableSuggestions == true) {
      (dictionary as Map<String, dynamic>).forEach(
        (key, value) {
          if (suggestionCount < 300) {
            // Search by beggining
            if (searchByBeginning) {
              if (key.startsWith(word)) {
                if (!suggestionsList.contains(key)) {
                  suggestionsList.add(key);
                  suggestionCount++;
                }
              }
              // Search by containment
            } else {
              if (key.contains(word)) {
                if (!suggestionsList.contains(key)) {
                  suggestionsList.add(key);
                  suggestionCount++;
                }
              }
            }
          }
        },
      );
    }
    setState(() {});
  }

  // Settings
  void settings() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "Settings",
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(color: Colors.black),
              SizedBox(height: 10.0),
              // Enable Word Suggestion
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Enable Word Suggestions",
                  ),
                  CupertinoSwitch(
                    value: enableSuggestions,
                    onChanged: (value) {
                      enableSuggestions = !enableSuggestions;
                      setState(() {});
                    },
                  )
                ],
              ),
              Divider(),
              // Enable Word Suggestion
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Suggest words by begining",
                  ),
                  CupertinoSwitch(
                    value: searchByBeginning,
                    onChanged: (value) {
                      searchByBeginning = !searchByBeginning;
                      setState(() {});
                    },
                  )
                ],
              ),
              Spacer(),
              // Remarks
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "made with 🤎 by dream intelligence!",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // TTS IMPLEMENTATION

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic receivedData = ModalRoute.of(context).settings.arguments;
    dictionary = receivedData["dictionary"];
    return Scaffold(
      backgroundColor: Colors.grey[300],
      // APP BAR
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(
          "Lexicon",
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              settings();
            },
          ),
        ],
      ),
      // Body
      body: SafeArea(
        child: ListView(
          children: [
            // Main Screen
            Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search
                  Row(
                    children: [
                      // Input box
                      Expanded(
                        child: TextField(
                          controller: searchedWord,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.menu_book_rounded,
                            ),
                          ),
                          onEditingComplete: () => {
                            searchForMeaning(searchedWord.text
                                .toString()
                                .toLowerCase()
                                .trim())
                          },
                          onChanged: (value) =>
                              {suggestions(value.toString().toLowerCase())},
                        ),
                      ),
                      // Seacrch Button
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          searchForMeaning(searchedWord.text
                              .toString()
                              .toLowerCase()
                              .trim());
                        },
                      )
                    ],
                  ),
                  // Results
                  Container(
                    child: showMeaningCard
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Searched Word
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.0),
                                  color: showMeaningCard
                                      ? Colors.white
                                      : Colors.grey[300],
                                ),
                                clipBehavior: Clip.hardEdge,
                                margin: EdgeInsets.only(top: 15.0),
                                child: Card(
                                  elevation: 0.0,
                                  color: showMeaningCard
                                      ? Colors.white
                                      : Colors.grey[300],
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          searchedTerm,
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            // Copy button
                                            IconButton(
                                              icon: Icon(Icons.copy),
                                              onPressed: () {
                                                String sharedWord = (searchedTerm +
                                                        "\n \n" +
                                                        meaning +
                                                        "\n \n \n \n" +
                                                        "Lexicon \nMade with 🤎 from Dream Intelligence!")
                                                    .toString();
                                                Clipboard.setData(
                                                        new ClipboardData(
                                                            text: sharedWord))
                                                    .then((_) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Copied to clipboard")));
                                                });
                                              },
                                            ),
                                            // Share Button
                                            IconButton(
                                              icon: Icon(Icons.share_outlined),
                                              onPressed: () {
                                                String sharedWord = (searchedTerm +
                                                        "\n \n" +
                                                        meaning +
                                                        "\n \n \n \n" +
                                                        "Lexicon \nMade with 🤎 from Dream Intelligence!")
                                                    .toString();
                                                Share.share(sharedWord);
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Definition
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: showMeaningCard
                                      ? Colors.grey[100]
                                      : Colors.grey[300],
                                ),
                                clipBehavior: Clip.hardEdge,
                                margin: EdgeInsets.only(top: 6.0),
                                child: Card(
                                  elevation: 0.0,
                                  color: showMeaningCard
                                      ? Colors.grey[100]
                                      : Colors.grey[300],
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.all(15.0),
                                    // Searched Word and It's meaning + Errors
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Meaning
                                        Text(
                                          meaning,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Clear Button
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: showMeaningCard
                                      ? Colors.grey[900]
                                      : Colors.grey[300],
                                ),
                                clipBehavior: Clip.hardEdge,
                                width: 120.0,
                                height: 40.0,
                                margin: EdgeInsets.only(top: 6.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.grey[900],
                                    ),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.zero),
                                  ),
                                  onPressed: () {
                                    showMeaningCard = false;
                                    enableSuggestions = false;
                                    searchedWord.clear();
                                    setState(() {});
                                  },
                                  child: Text(
                                    "Clear",
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ),
                  // Suggestions
                  Container(
                    child: enableSuggestions
                        ? Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 50.0, right: 50.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 500.0,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () => {
                                            searchForMeaning(
                                                suggestionsList[index]
                                                    .toString()
                                                    .toLowerCase()
                                                    .trim())
                                          },
                                          child: Text(
                                            suggestionsList[index],
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontStyle: FontStyle.italic,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: suggestionsList.length,
                                    ),
                                  ),
                                ].toList(),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
