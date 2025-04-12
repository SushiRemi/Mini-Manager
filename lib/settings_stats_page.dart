import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
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

    Timer(const Duration(milliseconds: 200), () => setState(() {
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

    Timer(const Duration(milliseconds: 1000), () => setState(() {
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

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    data.loadAll();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("assets/coins.png"),
                width: 40,
                height: 40,
              ),
              Text(
                coins.toString() + "     ",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              )
            ],
          )

        ],
      ),
      body: Center(
          child: Column(
            children: [
              //Project List
              Expanded(
                  flex: 7,
                  child: ListView(
                    children: [
                      Text("Coins: $coins", style: TextStyle(fontSize: 25)),
                      Text("Coins Earned: $coinsEarned", style: TextStyle(fontSize: 25)),
                      Text("Coins Spent: $coinsSpent", style: TextStyle(fontSize: 25)),
                      Text("Items Bought: $itemsBought", style: TextStyle(fontSize: 25)),
                      Text("Current Content Streak: $contentStreak", style: TextStyle(fontSize: 25)),
                      Text("Longest Content Streak: $longestStreak", style: TextStyle(fontSize: 25)),
                      Text("Projects Created: $projectsCreated", style: TextStyle(fontSize: 25)),
                      Text("Projects Completed: $projectsCompleted", style: TextStyle(fontSize: 25)),
                      Text("Projects Failed: $projectsFailed", style: TextStyle(fontSize: 25)),
                      Text("Content Created: $contentCreated", style: TextStyle(fontSize: 25)),
                      Text("Content Completed: $contentCompleted", style: TextStyle(fontSize: 25)),
                      Text("Content Failed: $contentFailed", style: TextStyle(fontSize: 25)),
                      Text("Coin Multiplier: $coinMultiplier", style: TextStyle(fontSize: 25)),

                      //How to use button
                      OutlinedButton(
                        onPressed:
                            () => showDialog<String>(
                          context: context,
                          builder:
                              (BuildContext context) => AlertDialog(
                            title: const Text('How To Use MiniMana'),
                            content: const Flex(
                              mainAxisAlignment: MainAxisAlignment.start,
                              direction: Axis.vertical,
                              children: [
                                Text("Welcome to MiniMana! This application aims to help musicians and other"
                                    " creatives with scheduling and staying on top of their online presence.\n"),
                                Text("The app is split into four main pages:\n"),
                                Text("Calendar Page", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("Here you can view your content calendar, which displays the days "
                                    "which you have content releases scheduled for. In addition, you can "
                                    "tap on the content for the selected day to mark it either as complete "
                                    "or as canceled, which will affect your coin and coin multiplier accordingly.\n"),
                                Text("Projects Page", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("Here you can create new projects using the button at the top, or tap on "
                                    "an existing project to view details and edit/delete projects or content "
                                    "as needed.\n"),
                                Text("Shop Page", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("Here you can create new items using the button at the top, or tap on "
                                    "an existing item to buy or edit the details. These are your rewards "
                                    "for sticking to a schedule, which you can spend coins on!\n"),
                                Text("Stats/Settings Page", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("Here you can view your stats for your account, as well as access other "
                                    "settings and options to sign out, or delete your data/account.\n"),
                                Text("Happy creating!")
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Back'),
                                child: const Text('Back'),
                              ),
                            ],
                          ),
                        ),
                        child: const Text("How to use MiniMana"),
                      ),
                      //About/Credits button
                      OutlinedButton(
                        onPressed:
                            () => showDialog<String>(
                          context: context,
                          builder:
                              (BuildContext context) => AlertDialog(
                            title: const Text('About MiniMana'),
                            content: const Flex(
                              direction: Axis.vertical,
                              children: [
                                Text("MiniMana was created as a way to cut out the most annoying parts of being "
                                    "a musician: content management. There were times where I wished that "
                                    "someone would just tell me what to do, when to post, so I could focus ,"
                                    "on the fun part of actually making music and videos. I would spend hours "
                                    "doing scheduling and research on release schedules, just wishing I could "
                                    "be writing instead.\n\n"
                                    "Upon initial brainstorming, I realized that I could solve another problem: "
                                    "discipline. One's passion for their art can only take you so far, and having "
                                    "to constantly be making new content, posts, videos for social media is taxing, "
                                    "which led to the reward shop system. The concept is simple: you stick to the "
                                    "schedule, you treat yourself to cool rewards! It's a simple concept and locked "
                                    "to the honor system, but the feeling of earning things is very effective.\n"),
                                Text("This application was made for the CS 4750.01 course at California Polytechnic "
                                    "State University, Pomona in the Spring 2025 Semester.\n"),
                                Text("Special thanks to Jae and Cassie for the moral support! <3\n"),
                                Text("Created with love by Julianne/Remskii"),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Back'),
                                child: const Text('Back'),
                              ),
                            ],
                          ),
                        ),
                        child: const Text("About/Credits"),
                      ),
                      //Reset Data Button
                      OutlinedButton(
                        onPressed:
                            () => showDialog<String>(
                          context: context,
                          builder:
                              (BuildContext context) => AlertDialog(
                            title: const Text('Reset Data?'),
                            content:
                            Text("Are you sure you want to reset all your stats and data? "
                                "You will lose all your created projects, coins, stats, and items. "
                                "This action is not reversible."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Back'),
                                child: const Text('Back'),
                              ),
                              TextButton(
                                onPressed: (){
                                  data.deleteAll();
                                  updateStats();
                                },
                                child: const Text("Delete All Data"),
                              ),

                            ],
                          ),
                        ),

                        child: const Text("Reset All Data"),
                      ),
                      //Sign out Button
                      OutlinedButton(
                        onPressed:
                            () => showDialog<String>(
                          context: context,
                          builder:
                              (BuildContext context) => AlertDialog(
                            title: const Text('Sign Out?'),
                            content:
                            Text("This action will sign you out of your account and take you back to the login page."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Back'),
                                child: const Text('Back'),
                              ),
                              TextButton(
                                onPressed: (){
                                  FirebaseAuth.instance.signOut();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthPage(title: "Authentication")));
                                },
                                child: const Text("Sign Out"),
                              ),

                            ],
                          ),
                        ),

                        child: const Text("Sign Out"),
                      ),
                      //Reset Password Button
                      OutlinedButton(
                        onPressed:
                            () => showDialog<String>(
                          context: context,
                          builder:
                              (BuildContext context) => AlertDialog(
                            title: const Text('Reset Password?'),
                            content:
                            Text("This action will send you an email to reset your password."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Back'),
                                child: const Text('Back'),
                              ),
                              TextButton(
                                onPressed: (){
                                  FirebaseAuth.instance.sendPasswordResetEmail(email: FirebaseAuth.instance.currentUser?.email as String);
                                  Navigator.pop(context);
                                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthPage(title: "Authentication")));
                                },
                                child: const Text("Send Reset Email"),
                              ),

                            ],
                          ),
                        ),
                        child: const Text("Reset Password"),
                      ),
                      //Delete Account Button
                      OutlinedButton(
                        onPressed:
                            () => showDialog<String>(
                          context: context,
                          builder:
                              (BuildContext context) => AlertDialog(
                            title: const Text('Delete Account?'),
                            content:
                            Text("This action will delete your account and all its data, then take you back to the login page. "
                                "This action can not be reversed."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Back'),
                                child: const Text('Back'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await data.deleteAll();
                                  await data.deleteFromFirebase();
                                  data.loadAll();
                                  await FirebaseAuth.instance.currentUser?.delete();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthPage(title: "Authentication")));
                                },
                                child: const Text("Delete Account"),
                              ),

                            ],
                          ),
                        ),

                        child: const Text("Delete Account"),
                      ),

                    ],
                  )
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
                        icon: Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: queryData.size.width/6,
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
                        icon: Icon(
                            Icons.file_copy,
                            color: Colors.white,
                            size: queryData.size.width/6,
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
                        icon: Icon(
                            Icons.currency_exchange,
                            color: Colors.white,
                            size: queryData.size.width/6,
                            semanticLabel: 'Shop Page'
                        ),
                      ),

                      //Settings Page
                      IconButton(
                        onPressed: null,
                        icon: Icon(
                            Icons.settings,
                            color: Colors.yellow,
                            size: queryData.size.width/6,
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
