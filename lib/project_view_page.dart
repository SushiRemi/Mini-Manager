import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_manager/edit_content_page.dart';
import 'package:mini_manager/edit_project_page.dart';
import 'package:mini_manager/project.dart';
import 'package:mini_manager/content.dart';

//used for description text
import 'package:expandable_text/expandable_text.dart';


class ProjectViewPage extends StatefulWidget {
  const ProjectViewPage({super.key, required this.title, required this.project, required this.index});

  final String title;
  final Project project;
  final int index;

  @override
  State<ProjectViewPage> createState() => _ProjectViewPage(project, index);
}

class _ProjectViewPage extends State<ProjectViewPage> {

  Project project = Project.empty();
  String title = "";
  String description = "";
  String status = "";
  String type = "";
  int coinValue = 0;
  DateTime releaseDate = DateTime(2025, 03, 11);
  String dateString = "";
  int index = -1;

  //For dynamically displaying content
  final List<DynamicWidget> _contentWidgetList = [];

  _ProjectViewPage(Project projectIn, int indexIn){
    project = projectIn;
    title = project.getTitle();
    description = project.getDescription();
    status = project.getStatus();
    type = project.getType();
    coinValue = project.getCoinValue();
    releaseDate = project.getReleaseDate();
    dateString = "Release Date: ${releaseDate.toString().substring(0, 10)}";
    index = indexIn;
    for (int i=0; i< project.getContentList().length; i++){
      _contentWidgetList.add(DynamicWidget(project.getContent(i), index, i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: (){
                  print("Edit Project");
                  //Should change to project viewing page
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(builder: (context) => EditProjectPage(title: "Edit Project", project: project, index: index)),
                  );
                },
                child: Column(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 38,
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
            ),
            Column(
              children: _contentWidgetList,
            )
          ],
        ),
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
  int projectIndex = -1;
  int contentIndex = -1;
  Content content = Content.empty();

  DynamicWidget(Content contentIn, int projectIndexIn, int contentIndexIn, {super.key}){
    content = contentIn;
    title = content.getTitle();
    parent = content.getParent();
    description = content.getDescription();
    status = content.getStatus();
    type = content.getType();
    coinValue = content.getCoinValue();
    projectIndex = projectIndexIn;
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
        color: Colors.blue,
        //height: 100,
        //width: 100,
        child: TextButton(
          onPressed: (){
            //Should change to content viewing page, currently to project for testing
            Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (context) => EditContentPage(title: "Edit Content", projectIndex: projectIndex, contentIndex: contentIndex, content: content,)
                )
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
    );
  }
}