import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_manager/data_manager.dart';
import 'package:mini_manager/project.dart';
import 'package:mini_manager/projects_page.dart';

//used for info text
import 'package:expandable_text/expandable_text.dart';
import 'package:mini_manager/shop_page.dart';

class NewItemPage extends StatefulWidget {
  const NewItemPage({super.key, required this.title, required this.index});

  final String title;
  final int index;

  @override
  State<NewItemPage> createState() => _NewItemPage();
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

class _NewItemPage extends State<NewItemPage> {
  int projectIndex = 0;
  Project project = Project.empty();
  DataManager data = DataManager();

  //for project creation
  String pTitle = "";
  String pDescription = "";
  String pType = "Album";
  int pMainContentAmount = -1;
  DateTime pReleaseDate = DateTime(0);


  //save projects to file
  void _save() {
    data.saveProjects();
    data.saveStats();
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
  void _submitItem(){
    print("Title: $pTitle");
    print("Description: $pDescription");
    print("Type: $pType");
    print("Main Content Amount: $pMainContentAmount");
    print("Release Date: $pReleaseDate");
    print("SUBMITTED");

    //Check if enough info is filled out
    if(pTitle != "" && pMainContentAmount != -1 && pReleaseDate.compareTo(DateTime(0)) != 0 && DateTime.now().compareTo(pReleaseDate) < 0){
      print("VALID");
      //Create and save into data, then destroy page and go back to projects.
      Project newProject = Project.createNew(pTitle, pType, pDescription, pReleaseDate, pMainContentAmount);
      data.projectList.add(newProject);
      int contentAmount = newProject.getContentList().length;
      data.sortProjects();
      data.createProject(contentAmount);
      _save();
      data.saveToFirebase();
      print("Item sent to data manager");

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ShopPage(title: "Shop Page")),
          ModalRoute.withName("Shop Page")
      );

    } else {
      print("INVALID");
    }
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
                          "Item Name: ",
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
                        TextField(
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          onChanged: (String value) {
                            pDescription = value;
                          },
                          maxLines: null,
                        )
                      ]
                  )
              ),
              //Item Icon Field
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
                                  "Item Icon: ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                DropdownMenu(
                                  width: 200,
                                  dropdownMenuEntries: TypeLabel.entries,
                                  initialSelection: TypeLabel.album,
                                  onSelected: (TypeLabel? selectedType){
                                    setState(() {
                                      pType = selectedType!.value;
                                    });
                                  },
                                ),
                              ]
                          ),
                        ),

                        //Item Cost
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Item Cost: ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                TextField(
                                    groupId: project.getContentList().length,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    onChanged: (String value) {pMainContentAmount = int.parse(value);}
                                )
                              ]
                          ),
                        ),
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
                  _submitItem();
                },
                child: const Text(
                  "Create Item",
                ),
              ),
            ],
          )
      ),
    );
  }
}
