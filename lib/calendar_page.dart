import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_manager/content_status_page.dart';
import 'package:mini_manager/projects_page.dart';
import 'package:mini_manager/settings_stats_page.dart';
import 'package:mini_manager/shop_page.dart';
import 'package:mini_manager/main.dart';
import 'package:mini_manager/data_manager.dart';
import 'package:mini_manager/project.dart';
import 'package:mini_manager/content.dart';

//for loading data after first building widget
import 'package:after_layout/after_layout.dart';

//used for description text
import 'package:expandable_text/expandable_text.dart';


//used for swiping between pages
import 'package:go_router/go_router.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:table_calendar/table_calendar.dart';
import 'go_router.dart';

//used for firebase data access
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum NavigationMode{
  navigator,
  goRouter,
  goRouterBuilder;

  static const current = NavigationMode.navigator; //change this to switch between navigation modes
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.title});

  final String title;

  @override
  State<CalendarPage> createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> with AfterLayoutMixin<CalendarPage>{
  //DataManager data = DataManager();
  DataManager data = DataManager();
  int counter = 0;

  //For calendar interactivity initialization
  DateTime _selectedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  CalendarFormat _calendarFormat = CalendarFormat.month;

  //For dynamically displaying events
  List<DynamicWidget> _contentWidgetList = [];
  List<int> indexList = [];
  List<int> contentIndexList = [];
  int coins = 0;

  void _save() {
    data.saveProjects();
  }

  void _load() {
    data.loadProjects();
    data.loadStats();
    print("loaded projects");
  }

  //To get events for selected day
  List<Content> _getEventsForDay(DateTime day){
    //return content list for that day
    List<Content> contentList = [];
    indexList.clear();
    contentIndexList.clear();
    //print(day);
    for(int i=0; i<data.projectList.length; i++){
      //checks if day is within project range
      Project currentProject = data.projectList[i];
      //print(currentProject.toCSV());
      for (int j=0; j<currentProject.getContentList().length; j++){
        //Check if content is for current day
        DateTime date = currentProject.getContentList()[j].getDate();
        String currentDate = date.toString();
        //print("Checking Content: $currentDate");
        if (date.year == day.year && date.month == day.month && date.day == day.day){
          //print("CONTENT FOUND");
          contentList.add(currentProject.getContentList()[j]);
          indexList.add(i);
          contentIndexList.add(j);
          //print("Content Index: $j");
        }
      }
    }

    return contentList;
  }

  List<DynamicWidget> _updateContentWidgetList(List<Content> contentList){
    List<DynamicWidget> newContentList = [];
    //print(contentIndexList.toString());
    for(int i=0; i<contentList.length; i++){
      newContentList.add(DynamicWidget(contentList[i], indexList[i], contentIndexList[i]));
    }
    //newContentList.add(DynamicWidget.test(_selectedDay));
    return newContentList;
  }

  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
        () => 'Data Loaded',
  );

  @override
  void afterFirstLayout(BuildContext context)  {
    // Calling the same function "after layout" to resolve the issue.
    setState(() {
      _focusedDay = DateTime.now();
      _contentWidgetList = _updateContentWidgetList(_getEventsForDay(DateTime.now()));
    });
  }

  @override
  void initState() {
    super.initState();
    print(FirebaseAuth.instance.currentUser!.email.toString());
    // data.loadFromFirebase();
    // data.saveAll();
    Timer(const Duration(milliseconds: 200), () => setState(() {
      _focusedDay = DateTime.now();
      _contentWidgetList = _updateContentWidgetList(_getEventsForDay(DateTime.now()));
      coins = data.stats.coins;
    }));
    Timer(const Duration(milliseconds: 1000), () => setState(() {
      _focusedDay = DateTime.now();
      _contentWidgetList = _updateContentWidgetList(_getEventsForDay(DateTime.now()));
      coins = data.stats.coins;
    }));
  }

  @override
  Widget build(BuildContext context) {
    _load(); //loads in data on build

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

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

        child: Stack(
          //Swipe left to go to shop
            children: [
              // GestureDetector(
              //   onPanUpdate: (details) {
              //     //swiping in left direction
              //     if (details.delta.dx < 0){
              //       _pushProjectsPage(context);
              //     }
              //   }
              // ),

              Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: TableCalendar(
                      focusedDay: _focusedDay,
                      firstDay: DateTime.utc(2025, 02, 25),
                      lastDay: DateTime.utc(2225, 02, 25),

                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },

                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay; // update `_focusedDay` here as well
                          _contentWidgetList = _updateContentWidgetList(_getEventsForDay(selectedDay));
                        });
                      },

                      calendarFormat: _calendarFormat,
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },

                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                        _contentWidgetList = _updateContentWidgetList(_getEventsForDay(focusedDay));
                      },

                      //Calls function to get events, can configure however i like
                      eventLoader: (day) {
                        //_load();
                        _updateContentWidgetList(_getEventsForDay(day));
                        return _getEventsForDay(day);
                      },

                    ),
                  ),

                  //For displaying events
                  Expanded(
                    flex: 3,
                    child: ListView(
                      children: _contentWidgetList = _updateContentWidgetList(_getEventsForDay(_focusedDay)),
                    ),
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
                                setState(() {
                                  _focusedDay = DateTime.now();
                                  _contentWidgetList = _updateContentWidgetList(_getEventsForDay(DateTime.now()));
                                });
                              },
                              icon: Icon(
                                Icons.calendar_month,
                                color: Colors.yellow,
                                size: queryData.size.width/6,
                                semanticLabel: 'Calendar Page'
                              ),
                          ),

                          //Project Page
                          IconButton(
                            onPressed: (){
                              _save();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => ProjectsPage(title: "Projects")),
                                ModalRoute.withName("Projects")
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
                              _save();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => ShopPage(title: "Shop")),
                                ModalRoute.withName("Shop")
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
                            onPressed: (){
                              _save();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => SettingsStatsPage(title: "SettingsStats")),
                                ModalRoute.withName("SettingsStats")
                              );
                            },
                            icon: Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: queryData.size.width/6,
                                semanticLabel: 'Settings Page'
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              ),


            ]
        )

      ),


    );
  }
}

// widget for dynamic text field
class DynamicWidget extends StatelessWidget {
  String title = "";
  String parent = "";
  String description = "";
  String status = "";
  String type = "";
  int coinValue = 0;
  Content content = Content.empty();
  int parentIndex = -1;
  int contentIndex = -1;

  DynamicWidget(Content contentIn, int parentIndexIn, int contentIndexIn, {super.key}){
    content = contentIn;
    title = content.getTitle();
    parent = content.getParent();
    description = content.getDescription();
    status = content.getStatus();
    type = content.getType();
    coinValue = content.getCoinValue();
    parentIndex = parentIndexIn;
    contentIndex = contentIndexIn;
  }

  DynamicWidget.empty({super.key}){
    title = "Hello";
    parent = "Parent Project";
    description = "TEST";
    status = "TEST";
    type = "TEST";
    coinValue = 100;
  }

  DynamicWidget.test(DateTime day, {super.key}){
    title = day.toString();
    parent = "PARENT PROJECT";
    description = "description here, this is where the description is description here, this is where the description isdescription here, this is where the description isdescription here, this is where the description is";
    status = "Status Here";
    type = "Type Here";
    coinValue = 111;
  }


  @override
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(0.0),
      color: Colors.black,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(0.0),
        color: Colors.blue,
        //height: 100,
        //width: 100,
        child: TextButton(
          onPressed: (){
            //Can only access if it is marked as In Progress or Incomplete
            if(status.contains("Incomplete") || status.contains("In Progress")){
              Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (context) => ContentStatusPage(title: "Content Status", content: content, parentIndex: parentIndex, contentIndex: contentIndex)),
              );
            }
          },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  ("Project: $parent"),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                ExpandableText(
                  description,
                  expandText: "Show Full",
                  collapseText: "Show Less",
                  maxLines: 1,
                  animation: true,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                  ),
                ),
                Row(
                    children: [
                      Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            type,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                      ),
                      Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            status,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                      ),
                      Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                image: AssetImage("assets/coins.png"),
                                width: 20,
                                height: 20,
                              ),
                              Text(
                                coinValue.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )

                      ),
                    ]
                ),

              ]
          ),
        )
    )

    );
  }
}