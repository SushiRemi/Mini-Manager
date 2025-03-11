import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_manager/calendar_page.dart';
import 'package:mini_manager/content.dart';
import 'package:mini_manager/project.dart';
import 'package:mini_manager/data_manager.dart';

class ContentStatusPage extends StatefulWidget {
  const ContentStatusPage({super.key, required this.title, required this.content, required this.parentIndex});

  final String title;
  final Content content;
  final int parentIndex;

  @override
  State<ContentStatusPage> createState() => _ContentStatusPage(content, parentIndex);
}

class _ContentStatusPage extends State<ContentStatusPage> {

  DataManager data = DataManager();

  Content content = Content.empty();
  String title = "";
  Project parent = Project.empty();
  String parentTitle = "";
  String status = "";
  String type = "";
  int coinValue = 0;
  String description = "";
  int parentIndex = -1;
  DateTime releaseDate = DateTime(0,0,0);
  String releaseDateString = "";

  _ContentStatusPage(Content contentIn, int parentIndexIn){
    data.loadAll();
    parentIndex = parentIndexIn;
    content = contentIn;
    title = content.getTitle();
    parentTitle = content.getParent();
    status = content.getStatus();
    type = content.getType();
    coinValue = content.getCoinValue();
    description = content.getDescription();
    releaseDate = content.getDate();
    releaseDateString = releaseDate.toString().substring(0,10);
  }

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 1), () => setState(() {
      //print(parentIndex);
      parent = data.projectList[parentIndex];
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 33,
                color: Colors.red,
              ),
            ),
            Text(
              "From project: $parentTitle",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Text(
              "Release Date: $releaseDateString",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Coin Value: ",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const Image(
                  image: AssetImage("assets/coins.png"),
                  //width: 200,
                  height: 30,
                ),
                Text(
                  "$coinValue",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  style: const ButtonStyle(
                      textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(
                        fontSize: 33,
                        color: Colors.purple,
                      ))
                  ),
                  onPressed:
                      () => showDialog<String>(
                    context: context,
                    builder:
                        (BuildContext context) => AlertDialog(
                      title: const Text('Delete Project?'),
                      content: const Text('This will completely delete the project and all related content. Your coin amount and streak will not be affected.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            //_deleteContent();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const CalendarPage(title: "Calendar")),
                                ModalRoute.withName("Projects")
                            );
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  child: const Text('Delete Project'),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
