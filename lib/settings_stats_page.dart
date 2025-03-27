import 'package:flutter/material.dart';
import 'package:mini_manager/data_manager.dart';
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
  DataManager data = DataManager();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void initState(){
    super.initState();
    data.loadAll();
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
                      Text("Test stat"),
                      Text("Test stat"),
                      Text("Test stat"),
                      Text("Test stat"),
                      Text("Test stat"),
                    ],
                  )
              ),

              FloatingActionButton(
                  onPressed: (){
                    data.deleteAll();
                  },
                child: const Text("DELETE ALL FILES"),
              ),
              FloatingActionButton(
                onPressed: (){
                  for (int i=0; i< data.projectList.length; i++){
                    print(data.projectList[i].toCSV());
                  }

                },
                child: const Text("Show All Projects"),
              ),
              FloatingActionButton(
                onPressed: (){
                  data.saveToFirebase();
                },
                child: const Text("Save to firebase"),
              ),
              FloatingActionButton(
                onPressed: (){
                  data.loadFromFirebase();
                },
                child: const Text("Load from firebase"),
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
