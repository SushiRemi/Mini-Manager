import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_manager/calendar_page.dart';
import 'package:mini_manager/content.dart';
import 'package:mini_manager/project.dart';
import 'package:mini_manager/data_manager.dart';

class ContentStatusPage extends StatefulWidget {
  const ContentStatusPage({super.key, required this.title, required this.content, required this.parentIndex, required this.contentIndex});

  final String title;
  final Content content;
  final int parentIndex;
  final int contentIndex;

  @override
  State<ContentStatusPage> createState() => _ContentStatusPage(content, parentIndex, contentIndex);
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
  int contentIndex = -1;
  DateTime releaseDate = DateTime(0,0,0);
  String releaseDateString = "";

  _ContentStatusPage(Content contentIn, int parentIndexIn, int contextIndexIn){
    data.loadAll();
    parentIndex = parentIndexIn;
    contentIndex = contextIndexIn;
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

              ],
            ),
            Text(
              ("Current Coin Multiplier: " + data.stats.coinMultiplier.toString() + "x"),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Complete Content Button
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
                      title: const Text('Complete Content?'),
                      content: const Text('This will mark the content as complete and give you the marked amount of coins. If completed on time or early, your coin multiplier will increase. If late, you will still earn coins but your multiplier will be reset. This action can not be undone.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            //Set content as complete
                            print("Project Index: $parentIndex");
                            print("Content Index: $contentIndex");
                            data.projectList[parentIndex].getContent(contentIndex).setStatus("Completed");

                            //Add coins to stats
                            data.earnCoins(coinValue);
                            data.completeContent();

                            DateTime now = DateTime.now();
                            DateTime today = DateTime(now.year, now.month, now.day);
                            if(releaseDate.compareTo(today) < 0){
                              data.stats.contentStreak = 0;
                            }

                            //Check if project is complete in load function
                            //Save data
                            data.saveAll();
                            print(data.stats.coins);

                            //Return to Calendar Page
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
                  child: const Text('Complete'),
                ),

                //Cancel Content Button
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
                      title: const Text('Cancel Content?'),
                      content: const Text('This will mark the content as cancelled, and you will lose your coin multiplier. This action can not be undone.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            //Set content as complete
                            print("Project Index: $parentIndex");
                            print("Content Index: $contentIndex");
                            data.projectList[parentIndex].getContent(contentIndex).setStatus("Cancelled");

                            //Add coins to stats
                            //data.earnCoins(coinValue);
                            data.cancelContent();

                            //Check if project is complete in load function
                            //Save data
                            data.saveAll();
                            print(data.stats.coins);
                            print(data.stats.coinMultiplier);

                            //Return to Calendar Page
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
                  child: const Text('Cancel'),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }
}
