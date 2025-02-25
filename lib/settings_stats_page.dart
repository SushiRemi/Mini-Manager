import 'package:flutter/material.dart';
import 'package:mini_manager/projects_page.dart';
import 'package:mini_manager/shop_page.dart';
import 'package:mini_manager/calendar_page.dart';

class SettingsStatsPage extends StatefulWidget {
  const SettingsStatsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsStatsPage> createState() => _SettingsStatsPage();
}

class _SettingsStatsPage extends State<SettingsStatsPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      Text("Test stat"),
                      Text("Test stat"),
                      Text("Test stat"),
                      Text("Test stat"),
                      Text("Test stat"),
                    ],
                  )
              ),

              //Bottom Nav Bar
              Expanded(
                flex: 1,
                child: BottomAppBar(
                  color: Colors.green,
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
                            color: Colors.yellow,
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
                            color: Colors.yellow,
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
                            color: Colors.yellow,
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
