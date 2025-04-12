import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_manager/calendar_page.dart';
import 'package:mini_manager/new_project_page.dart';
import 'package:mini_manager/project_view_page.dart';
import 'package:mini_manager/projects_page.dart';
import 'package:mini_manager/shop_page.dart';
import 'package:mini_manager/settings_stats_page.dart';
import 'package:mini_manager/content.dart';
import 'package:mini_manager/project.dart';
import 'package:mini_manager/data_manager.dart';

//for loading data after first building widget
import 'package:after_layout/after_layout.dart';

//used for description text
import 'package:expandable_text/expandable_text.dart';

//used for swiping between pages
import 'package:go_router/go_router.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'go_router.dart';

enum NavigationMode{
  navigator,
  goRouter,
  goRouterBuilder;

  static const current = NavigationMode.navigator; //change this to switch between navigation modes
}

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key, required this.title});

  final String title;


  //DataManager data = DataManager();


  @override
  State<ProjectsPage> createState() => _ProjectsPage();
}

class _ProjectsPage extends State<ProjectsPage> with AfterLayoutMixin<ProjectsPage> {
  DataManager data = DataManager();
  int coins = 0;

  //For dynamically displaying projects
  List<ProjectWidget> _projectWidgetList = [];

  //save projects to file
  void _save() {
    data.saveProjects();
  }

  //load projects from file
  void _load() {
    data.loadProjects();
    data.loadStats();
  }

  //to update project widgets
  List<ProjectWidget> _updateProjectWidgetList(List<Project> projectList){
    List<ProjectWidget> newProjectList = [];
    //print(projectList.length);
    for(int i=0; i<projectList.length; i++){
      newProjectList.add(ProjectWidget(projectList[i], i));
    }
    //newProjectList.add(ProjectWidget.test());
    return newProjectList;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    _load();
    //print("Project List Length: ");
    // print(data.projectList.length);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  //Create new project button
                  Flex(
                    direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.black12,
                            child: TextButton(
                              onPressed: (){
                                _save();
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => NewProjectPage(title: "Add Project", index: -1,)),
                                );
                              },
                              child:
                              const Text(
                                "Create New Project",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                          ),
                        )
                      ]
                  ),

                  //Project List
                  Expanded(
                      child: ListView(
                        children: _projectWidgetList = _updateProjectWidgetList(data.projectList),
                      )
                  ),
                ],
              )
            ),

            //Bottom Nav Bar
            Expanded(
              flex: 1,
              child: BottomAppBar(
                color: const Color(0xFF290238),
                shape: const CircularNotchedRectangle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Calendar Page
                    IconButton(
                      onPressed: (){
                        _save();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => CalendarPage(title: "Calendar")),
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
                        setState(() {
                          _projectWidgetList = _updateProjectWidgetList(data.projectList);
                        });
                      },
                      icon: Icon(
                          Icons.file_copy,
                          color: Colors.yellow,
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
                      onPressed: (){
                        _save();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const SettingsStatsPage(title: "SettingsStats")),
                            ModalRoute.withName("Calendar")
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
            )

          ],
        ),

      ),

    );
  }

  @override
  void afterFirstLayout(BuildContext context) async{
    // Calling the same function "after layout" to resolve the issue.
    setState(() {
      _projectWidgetList = _updateProjectWidgetList(data.projectList);
    });
  }

  @override
  void initState() {
    super.initState();
    data.loadProjects();
    Timer(const Duration(milliseconds: 200), () => setState(() {
      _projectWidgetList = _updateProjectWidgetList(data.projectList);
      coins = data.stats.coins;
    }));
    Timer(const Duration(milliseconds: 1000), () => setState(() {
      _projectWidgetList = _updateProjectWidgetList(data.projectList);
      coins = data.stats.coins;
    }));
  }
}


// widget for dynamic text field
class ProjectWidget extends StatelessWidget {
  Project project = Project.empty();
  String title = "";
  String description = "";
  String status = "";
  String type = "";
  int coinValue = 0;
  DateTime releaseDate = DateTime(2025, 03, 11);
  int index = -1;

  ProjectWidget(Project projectIn, int indexIn, {super.key}){
    project = projectIn;
    title = projectIn.getTitle();
    description = projectIn.getDescription();
    status = projectIn.getStatus();
    type = projectIn.getType();
    coinValue = projectIn.getCoinValue();
    releaseDate = projectIn.getReleaseDate();
    index = indexIn;
  }

  ProjectWidget.empty({super.key}){
    title = "Hello";
    description = "TEST";
    status = "TEST";
    type = "TEST";
    coinValue = 100;
    releaseDate = DateTime(2025, 03, 11);
  }

  ProjectWidget.test({super.key}){
    title = "Test Project";
    description = "description here, this is where the description is description here, this is where the description isdescription here, this is where the description isdescription here, this is where the description is";
    status = "Status Here";
    type = "Type Here";
    coinValue = 111;
    releaseDate = DateTime(2025, 03, 11);
  }


  @override
  Widget build(BuildContext context){
    String releaseDateString = ("${releaseDate.month}/${releaseDate.day}/${releaseDate.year}");
    String dateString = (releaseDateString);
    return Container(
      color: Colors.black,
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(0.0),
      child:
      Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(0.0),
        color: Colors.blue,
        //height: 100,
        //width: 100,
        child: TextButton(
          onPressed: (){
            //Should change to project viewing page
            Navigator.of(context).push<void>(
              MaterialPageRoute(builder: (context) => ProjectViewPage(title: "Project View", project: project, index: index,)),
            );
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
                  dateString,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
                ExpandableText(
                  description,
                  expandText: "Show Full",
                  collapseText: "Show Less",
                  maxLines: 3,
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