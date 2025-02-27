import 'package:flutter/material.dart';
import 'package:mini_manager/projects_page.dart';
import 'package:mini_manager/settings_stats_page.dart';
import 'package:mini_manager/shop_page.dart';
import 'package:mini_manager/main.dart';
import 'package:mini_manager/data_manager.dart';
import 'package:mini_manager/project.dart';
import 'package:mini_manager/content.dart';


//used for swiping between pages
import 'package:go_router/go_router.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:table_calendar/table_calendar.dart';
import 'go_router.dart';

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

class _CalendarPage extends State<CalendarPage> {
  DataManager data = DataManager();
  int counter = 0;

  //For calendar interactivity initialization
  DateTime _selectedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _focusedDay = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  CalendarFormat _calendarFormat = CalendarFormat.month;

  //For dynamically displaying events
  List<DynamicWidget> _contentWidgetList = [];

  void _save() {
    data.saveProjects();
  }

  void _load() {
    data.loadProjects();
  }

  //To get events for selected day
  List<Content> _getEventsForDay(DateTime day){
    //return content list for that day
    List<Content> contentList = [];

    for(int i=0; i<data.projectList.length; i++){
      DateTime start = data.projectList[i].getStartDate();
      DateTime end = data.projectList[i].getEndDate();

      //checks if day is within project range
      if ((day.isAfter(start) || day.compareTo(start) == 0) && (day.isBefore(end) || day.compareTo(end) == 0)){
        Project currentProject = data.projectList[i];
        for (int j=0; j<currentProject.contentList.length; j++){
          //Check if content is for current day
          if (currentProject.contentList[j].getDate().compareTo(day) == 0){
            contentList.add(currentProject.contentList[j]);
          }
        }
      }
    }

    return contentList;
  }

  List<DynamicWidget> _updateContentWidgetList(List<Content> contentList){
    List<DynamicWidget> newContentList = [];
    for(int i=0; i<contentList.length; i++){
      newContentList.add(DynamicWidget(contentList[i]));
    }
    newContentList.add(DynamicWidget.test(_selectedDay));
    return newContentList;
  }

  @override
  Widget build(BuildContext context) {
    _load(); //loads in data on build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
                          const IconButton(
                              onPressed: null,
                              icon: Icon(
                                Icons.calendar_month,
                                color: Colors.yellow,
                                size: 75,
                                semanticLabel: 'Calendar Page'
                              ),
                          ),

                          //Project Page
                          IconButton(
                            onPressed: (){
                              _save();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => ProjectsPage(title: "Projects")),
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
                              _save();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => ShopPage(title: "Shop")),
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
                          IconButton(
                            onPressed: (){
                              _save();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => SettingsStatsPage(title: "SettingsStats")),
                                ModalRoute.withName("Calendar")
                              );
                            },
                            icon: const Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 75,
                                semanticLabel: 'Settings Page'
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ]
              ),


            ]
        )

      ),


    );
  }

  //Method to go to shop
  Future<void> _pushProjectsPage(BuildContext context) async {
    return switch (NavigationMode.current){
      NavigationMode.navigator => Navigator.of(context)
        .push<void>(SwipeablePageRoute(builder: (_) => const ProjectsPage(title: "Projects"))),
      NavigationMode.goRouter => GoRouter.of(context).push<void>('/projects'),
      NavigationMode.goRouterBuilder => ProjectsPageRoute().push(context),
    };
  }
}

// widget for dynamic text field
class DynamicWidget extends StatelessWidget {
  String title = "";
  String description = "";
  String status = "";
  String type = "";
  int coinValue = 0;

  DynamicWidget(Content content, {super.key}){
    title = content.getTitle();
    description = content.getDescription();
    status = content.getStatus();
    type = content.getType();
    coinValue = content.getCoinValue();
  }

  DynamicWidget.empty({super.key}){
    title = "Hello";
    description = "TEST";
    status = "TEST";
    type = "TEST";
    coinValue = 100;
  }

  DynamicWidget.test(DateTime day, {super.key}){
    title = day.toString();
    description = "description here, this is where the description is";
    status = "Status Here";
    type = "Type Here";
    coinValue = 111;
  }


  @override
  Widget build(BuildContext context){
    return Container(
      child: Container(
        color: Colors.blue,
        //height: 100,
        //width: 100,
        child: TextButton(
            onPressed: (){
              //Should change to content viewing page, currently to project for testing
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => ProjectsPage(title: "Projects")),
                  ModalRoute.withName("Calendar")
              );
            },
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,

                ),
                Text(description),
                Text(status),
                Text(type),
                Text(coinValue.toString()),
              ]
            ),
        )
      )
    );
  }
}