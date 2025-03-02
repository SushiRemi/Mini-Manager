import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_manager/data_manager.dart';
import 'package:mini_manager/project.dart';


class ProjectEditPage extends StatefulWidget {
  const ProjectEditPage({super.key, required this.title, required this.index});

  final String title;
  final int index;

  @override
  State<ProjectEditPage> createState() => _ProjectEditPage();
}

//DropdownMenuEntry labels and values for project type dropdown menu
typedef TypeEntry = DropdownMenuEntry<TypeLabel>;

enum TypeLabel {
  //select('Select', "select"),
  album('Album', "album"),
  ep('EP', "ep"),
  single('Single', "single"),
  other('Other', "other"),;

  const TypeLabel(this.label, this.value);
  final String label;
  final String value;

  static final List<TypeEntry> entries = UnmodifiableListView<TypeEntry>(
    values.map<TypeEntry>(
          (TypeLabel type) => TypeEntry(
        value: type,
        label: type.label,
        //enabled: type.label != 'Select',
        style: MenuItemButton.styleFrom(foregroundColor: Colors.black),
      ),
    ),
  );
}

class _ProjectEditPage extends State<ProjectEditPage> {
  int projectIndex = 0;
  Project project = Project.empty();
  DataManager data = DataManager();



  //save projects to file
  void _save() {
    data.saveProjects();
  }

  //load projects from file
  void _load() {
    data.loadProjects();
  }

  //overwrite the data of the project. don't forget to save after. be careful, this is destructive.
  void _overwriteProject(Project newProject, int index){
    data.projectList[index] = newProject;
  }

  @override
  Widget build(BuildContext context) {
    _load();
    projectIndex = widget.index;
    int contentAmount = 0;

    //loads in current or new project
    if(projectIndex >= 0){
      project = data.projectList[projectIndex];
    } else {
      project = Project.empty();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: [
            //Title Field
            Container(
              color: Colors.pinkAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Project Title: ",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),

                  ),
                  TextField(
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                      groupId: project.getTitle(),
                      onSubmitted: (String value) {
                        project.setTitle(value);
                      }
                  )
                ]
              )
            ),
            //Project Type Field
            Container(
              color: Colors.lightBlue,
                child: Row(
                  children: [
                    //Project Type
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Project Type: ",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              DropdownMenu(
                                width: 200,
                                dropdownMenuEntries: TypeLabel.entries,
                                initialSelection: TypeLabel.album,
                              ),
                            ]
                        ),
                    ),

                    //Main Content Amount
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Main Content Amount: ",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            TextField(
                              groupId: project.getContentList().length,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              onSubmitted: (String value) {contentAmount = int.parse(value);}
                            )
                          ]
                      ),
                    ),
                  ]
                )

            ),
            //Description Field
            Container(
                color: Colors.pinkAccent,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Project Description: ",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                        ),

                      ),
                      TextField(
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          groupId: project.getTitle(),
                          onSubmitted: (String value) {
                            project.setTitle(value);
                          }
                      )
                    ]
                )
            ),

          ],
        )
      ),
    );
  }
}
