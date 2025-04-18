import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_manager/data_manager.dart';
import 'package:mini_manager/project.dart';
import 'package:mini_manager/projects_page.dart';

//used for info text
import 'package:expandable_text/expandable_text.dart';

class EditProjectPage extends StatefulWidget {
  const EditProjectPage({super.key, required this.title, required this.project, required this.index});

  final String title;
  final Project project;
  final int index;

  @override
  State<EditProjectPage> createState() => _EditProjectPage(project, index);
}

//DropdownMenuEntry labels and values for project type dropdown menu
typedef TypeEntry = DropdownMenuEntry<TypeLabel>;

enum TypeLabel {
  //select('Select', "select"),
  album('Album', "Album"),
  ep('EP', "EP"),
  single('Single', "Single"),
  other('Other', "Other"),;

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

class _EditProjectPage extends State<EditProjectPage> {
  int projectIndex = 0;
  Project project = Project.empty();
  DataManager data = DataManager();

  //for project creation
  String pTitle = "";
  String pDescription = "";
  String pType = "Album";
  // int pMainContentAmount = -1;
  DateTime pReleaseDate = DateTime(0);
  TypeLabel pTypeLabel = TypeLabel.other;
  String pReleaseDateString = "";


  //Constructor
  _EditProjectPage(Project projectIn, int indexIn){
    projectIndex = indexIn;
    project = projectIn;
    pTitle = project.getTitle();
    pDescription = project.getDescription();
    pType = project.getType();
    pReleaseDate = project.getReleaseDate();
    pReleaseDateString = pReleaseDate.toString().substring(0,10);
    _dateController.text = pReleaseDateString;

    TypeLabel getLabel(String str){
      str = str.toLowerCase();
      if (str.contains("album")){
        return TypeLabel.album;
      } else if (str.contains("ep")){
        return TypeLabel.ep;
      } else if (str.contains("single")){
        return TypeLabel.single;
      } else if (str.contains("other")){
        return TypeLabel.other;
      } else {
        return TypeLabel.other;
      }
    }

    pTypeLabel = getLabel(pType);
    print(pTypeLabel.value);
  }

  //save projects to file
  void _save() {
    data.saveProjects();
  }

  //load projects from file
  void _load() {
    data.loadProjects();
  }

  //Date picker for release date form
  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2200)
    );

    if (_picked != null){
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
        pReleaseDate = _picked;
      });
    }
  }

  //Controller for date field viewer
  final TextEditingController _dateController = TextEditingController();

  //Attempt to create new project
  void _submitProject(){
    print("Title: $pTitle");
    print("Description: $pDescription");
    print("Type: $pType");
    //print("Main Content Amount: $pMainContentAmount");
    print("Release Date: $pReleaseDate");
    print("SUBMITTED");

    //Check if enough info is filled out
    if(pTitle != ""){
      print("VALID");
      //change project data at project index.
      // Project newProject = Project.createNew(pTitle, pType, pDescription, pReleaseDate, pMainContentAmount);
      // data.projectList.add(newProject);
      data.projectList[projectIndex].setTitle(pTitle);
      data.projectList[projectIndex].setDescription(pDescription);
      data.projectList[projectIndex].setType(pType);
      data.projectList[projectIndex].setReleaseDate(pReleaseDate);

      for(int i=0; i<data.projectList[projectIndex].getContentList().length; i++){
        data.projectList[projectIndex].getContent(i).setParent(data.projectList[projectIndex]);
      }

      data.sortProjects();
      _save();
      data.saveToFirebase();
      print("Project sent to data manager");

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ProjectsPage(title: "Projects")),
          ModalRoute.withName("Projects")
      );

    } else {
      print("INVALID");
    }
  }

  //Delete the current project
  void _deleteProject(){
    // print("Project Deleted");
    // print("Project Index: $projectIndex");
    // print(data.projectList[projectIndex].toCSV());
    int contentAmount = data.projectList[projectIndex].getContentList().length;
    data.deleteProject(contentAmount);
    data.projectList.removeAt(projectIndex);
    // print(data.projectList.length);
    data.saveAll();
    data.saveToFirebase();
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () => setState(() {
      project = data.projectList[projectIndex];
    }));
  }

  @override
  Widget build(BuildContext context) {
    _load();
    // int contentAmount = 0;

    //loads in current or new project
    if(projectIndex >= 0){
      print(projectIndex);
      //project = data.projectList[projectIndex];
    } else {
      //project = Project.empty();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView(
            children: [
              //Info Field
              const ExpandableText(
                "\nThe [Release Date] is the date on which you plan to release the final version of the project.\n\n"
                    "[Main Content] refers to any singles or partial projects you plan on releasing BEFORE the final version.\n\n"
                    "Each [Main Content] will generate by default 2 lead-up/teaser videos before the [Main Content] date. The scheduler will attempt to give 3 days of space between each upload, but will decrease if there is not enough time before the release date.\n\n"
                    "In addition, the project will automatically schedule two teaser videos before the final release date, and two post-release videos after the date.\n\n"
                    "It is strongly recommended to schedule the release date at least twice the amount of weeks in advance as there is main content (ex: 4 main content -> release date 8 weeks from today's date minimum).",
                expandText: "Show",
                collapseText: "Hide",
                prefixText: "How Project Creation Works:",
                prefixStyle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 1,
                animation: true,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
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
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          initialValue: pTitle,
                          onChanged: (String value){
                            pTitle = value; //set pTitle for project creation
                          },
                        )
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
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          onChanged: (String value) {
                            pDescription = value;
                          },
                          initialValue: pDescription,
                          maxLines: null,
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
                                  initialSelection: pTypeLabel,
                                  onSelected: (TypeLabel? selectedType){
                                    setState(() {
                                      pType = selectedType!.value;
                                    });
                                  },
                                ),
                              ]
                          ),
                        ),

                        //Main Content Amount
                        // Expanded(
                        //   child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         const Text(
                        //           "Main Content Amount: ",
                        //           style: TextStyle(
                        //             fontSize: 20,
                        //             color: Colors.black,
                        //           ),
                        //         ),
                        //         TextField(
                        //             groupId: project.getContentList().length,
                        //             keyboardType: TextInputType.number,
                        //             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        //             onChanged: (String value) {pMainContentAmount = int.parse(value);}
                        //         )
                        //       ]
                        //   ),
                        // ),
                      ]
                  )

              ),
              //Release Date Field
              Container(
                  color: Colors.lightBlue,
                  child: Row(
                      children: [
                        const Text(
                          "Release Date: ",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        Expanded(
                            child: Container(
                                color: Colors.yellow,
                                child:
                                TextField(
                                    //initialValue: pReleaseDateString,
                                    controller: _dateController,
                                    decoration: const InputDecoration(
                                      //labelText: "DATE",
                                      filled: true,
                                      prefixIcon: Icon(Icons.calendar_today),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blue)
                                      ),
                                    ),
                                    readOnly: true,
                                    onTap: (){
                                      _selectDate();
                                    },
                                )
                            )
                        )

                      ]
                  )

              ),
              //Submit Button
              TextButton(
                style: const ButtonStyle(
                    textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(
                      fontSize: 33,
                      color: Colors.purple,
                    ))
                ),
                onPressed: (){
                  _submitProject();
                },
                child: const Text(
                  "Save Edits",
                ),
              ),
              //Delete Button
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
                    title: const Text('Delete Project?'),
                    content: const Text('This will completely delete the project and all related content. Your coin amount and streak will not be affected.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _deleteProject();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const ProjectsPage(title: "Projects")),
                              ModalRoute.withName("Projects")
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
                child: const Text('Delete Project'),
              ),

        ],
          )
      ),
    );
  }
}
