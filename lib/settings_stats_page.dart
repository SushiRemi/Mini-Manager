import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_manager/data_manager.dart';
import 'package:mini_manager/projects_page.dart';
import 'package:mini_manager/shop_page.dart';
import 'package:mini_manager/calendar_page.dart';
import 'package:mini_manager/authpage.dart';

//import for logging out
import 'package:firebase_auth/firebase_auth.dart';

class SettingsStatsPage extends StatefulWidget {
  const SettingsStatsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsStatsPage> createState() => _SettingsStatsPage();
}

class _SettingsStatsPage extends State<SettingsStatsPage> {
  int _counter = 0;
  DataManager data = DataManager();

  int coins = 0;
  int coinsEarned = 0;
  int coinsSpent = 0;
  int itemsBought = 0;
  int contentStreak = 0;
  int longestStreak = 0;
  int projectsCreated = 0;
  int projectsCompleted = 0;
  int projectsFailed = 0;
  int contentCreated = 0;
  int contentCompleted = 0;
  int contentFailed = 0;
  double coinMultiplier = 0.0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void initState(){
    super.initState();
    data.loadAll();
    // coins = data.stats.coins;
    // coinsSpent = data.stats.coinsSpent;
    // coinsEarned = data.stats.coinsEarned;
    // itemsBought = data.stats.itemsBought;
    // contentStreak = data.stats.contentStreak;
    // longestStreak = data.stats.longestStreak;
    // projectsCreated = data.stats.projectsCreated;
    // projectsCompleted = data.stats.projectsCompleted;
    // projectsFailed = data.stats.projectsFailed;
    // contentCreated = data.stats.contentCreated;
    // contentCompleted = data.stats.contentCompleted;
    // contentFailed = data.stats.contentFailed;
    // coinMultiplier = data.stats.coinMultiplier;

    Timer(const Duration(seconds: 1), () => setState(() {
      coins = data.stats.coins;
      coinsSpent = data.stats.coinsSpent;
      coinsEarned = data.stats.coinsEarned;
      itemsBought = data.stats.itemsBought;
      contentStreak = data.stats.contentStreak;
      longestStreak = data.stats.longestStreak;
      projectsCreated = data.stats.projectsCreated;
      projectsCompleted = data.stats.projectsCompleted;
      projectsFailed = data.stats.projectsFailed;
      contentCreated = data.stats.contentCreated;
      contentCompleted = data.stats.contentCompleted;
      contentFailed = data.stats.contentFailed;
      coinMultiplier = data.stats.coinMultiplier;
    }));
  }

  void updateStats(){
    setState(() {
      coins = data.stats.coins;
      coinsSpent = data.stats.coinsSpent;
      coinsEarned = data.stats.coinsEarned;
      itemsBought = data.stats.itemsBought;
      contentStreak = data.stats.contentStreak;
      longestStreak = data.stats.longestStreak;
      projectsCreated = data.stats.projectsCreated;
      projectsCompleted = data.stats.projectsCompleted;
      projectsFailed = data.stats.projectsFailed;
      contentCreated = data.stats.contentCreated;
      contentCompleted = data.stats.contentCompleted;
      contentFailed = data.stats.contentFailed;
      coinMultiplier = data.stats.coinMultiplier;
    });
  }

  @override
  Widget build(BuildContext context) {
    data.loadAll();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
            children: [
              //Project List
              Expanded(
                  flex: 7,
                  child: ListView(
                    children: [
                      Text("Coins: $coins"),
                      Text("Coins Earned: $coinsEarned"),
                      Text("Coins Spent: $coinsSpent"),
                      Text("Items Bought: $itemsBought"),
                      Text("Current Content Streak: $contentStreak"),
                      Text("Longest Content Streak: $longestStreak"),
                      Text("Projects Created: $projectsCreated"),
                      Text("Projects Completed: $projectsCompleted"),
                      Text("Projects Failed: $projectsFailed"),
                      Text("Content Created: $contentCreated"),
                      Text("Content Completed: $contentCompleted"),
                      Text("Content Failed: $contentFailed"),
                      Text("Coin Multiplier: $coinMultiplier"),
                    ],
                  )
              ),

              OutlinedButton(
                onPressed: (){
                  updateStats();
                },
                child: const Text("Update Stats On Page"),
              ),
              OutlinedButton(
                  onPressed: (){
                    data.deleteAll();
                    updateStats();
                  },
                child: const Text("DELETE ALL FILES"),
              ),
              OutlinedButton(
                onPressed: (){
                  for (int i=0; i< data.projectList.length; i++){
                    print(data.projectList[i].toCSV());
                  }

                },
                child: const Text("Show All Projects"),
              ),
              OutlinedButton(
                onPressed: (){
                  data.saveToFirebase();
                },
                child: const Text("Save to firebase"),
              ),
              OutlinedButton(
                onPressed: (){
                  data.loadFromFirebase();
                },
                child: const Text("Load from firebase"),
              ),
              OutlinedButton(
                onPressed: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthPage(title: "Authentication")));
                },
                child: const Text("Sign Out"),
              ),

              //Bottom Nav Bar
              Expanded(
                flex: 1,
                child: BottomAppBar(
                  color: Color(0xFF290238),
                  shape: const CircularNotchedRectangle(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Calendar Page
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const CalendarPage(title: "Calendar")),
                              ModalRoute.withName("Calendar")
                          );
                        },
                        icon: const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 75,
                            semanticLabel: 'Calendar Page'
                        ),
                      ),

                      //Project Page
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const ProjectsPage(title: "Projects")),
                              ModalRoute.withName("Calendar")
                          );
                        },
                        icon: const Icon(
                            Icons.file_copy,
                            color: Colors.white,
                            size: 75,
                            semanticLabel: 'Project Page'
                        ),
                      ),

                      //Shop Page
                      IconButton(
                        onPressed: (){
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const ShopPage(title: "Shop")),
                              ModalRoute.withName("Calendar")
                          );
                        },
                        icon: const Icon(
                            Icons.currency_exchange,
                            color: Colors.white,
                            size: 75,
                            semanticLabel: 'Shop Page'
                        ),
                      ),

                      //Settings Page
                      const IconButton(
                        onPressed: null,
                        icon: Icon(
                            Icons.settings,
                            color: Colors.yellow,
                            size: 75,
                            semanticLabel: 'Settings Page'
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
