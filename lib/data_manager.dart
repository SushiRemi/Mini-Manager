//connecting to other pages
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_manager/project.dart';
import 'package:mini_manager/shopitem.dart';
import 'package:mini_manager/content.dart';
import 'package:mini_manager/stats.dart';

//imports for saving/loading files
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

//imports for saving/loading from firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';


class DataManager {
  //Initialize DataManager
  DataManager();

  //Lists of projects, items, and other stats tracked throughout program life
  var projectList = <Project>[];
  var shopList = <ShopItem>[];
  var stats = Stats(0,0,0,0,0,0,0,0,0,0,0,0); //includes coin amount

  //Setup firebase storage
  final storageRef = FirebaseStorage.instance;


  //_localPath is where we store files on the devices.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // print("directory found");
    return directory.path;
  }

  Future<File> get _projectsFile async {
    final path = await _localPath;
    // print("project file found");
    return File('$path/savedProjects.csv');
  }

  Future<File> get _itemsFile async {
    final path = await _localPath;
    // print("item file found");
    return File('$path/savedItems.csv');
  }

  Future<File> get _statsFile async {
    final path = await _localPath;
    // print("stats file found");
    return File('$path/savedStats.txt');
  }



//saves the current project, item, and stats to the save file.
  void saveAll(){
    saveProjects();
    saveShop();
    saveStats();
  }

//loads a project list, item list, and stats from a save file
  void loadAll(){
    loadProjects();
    loadShop();
    loadStats();
  }

  //Refreshes all files
  Future<void> deleteAll() async {
    final file1 = await _projectsFile;
    final file2 = await _statsFile;
    final file3 = await _itemsFile;

    file1.writeAsStringSync("");
    file2.writeAsStringSync("");
    file3.writeAsStringSync("");
  }


  String getPath(){
    return _localPath.toString();
  }

//saves the current projectList to a file
  Future<File> saveProjects() async{
    final file = await _projectsFile;

    sortProjects();

    if (projectList.isEmpty){
      file.writeAsStringSync("");
    }

    for (int i=0; i < projectList.length; i++){
      projectList[i].updateCompletion();

      if (i==0) {
        file.writeAsStringSync("${projectList[i].toCSV()}\n"); //erases all old data and starts fresh
      } else {
        file.writeAsStringSync("${projectList[i].toCSV()}\n", mode: FileMode.append); //appends to current
      }
    }
    //file.writeAsStringSync("hello");
    //file.writeAsStringSync(" universe!", mode: FileMode.append);

    // for(int i=0; i<projectList.length; i++){
    //   print(projectList[i].toCSV());
    // }

    return file;
  }

//loads a projectList from a file
  Future<int> loadProjects() async {
    try {
      final file = await _projectsFile;
      //print(file.toString());
      // Read the file
      final contents = await file.readAsLines();
      // print("Content length:");
      // print(contents.length);
      //Create temp projectList
      var tempList = <Project>[];

      // Create Projects/Content for each
      int projectIndex = 0;

      for (int i=0; i<contents.length; i++){
        var current = contents[i].split(',,');
        //print(i);
        //print(current);
        if(current[0].contains("project")){
          projectIndex = i;
          //print(projectIndex);
          // print("project found");
          DateTime tempDate = DateTime(int.parse(current[4].substring(0,4)), int.parse(current[4].substring(5,7)), int.parse(current[4].substring(8,10)));
          // print("dateTime processed");
          // print(current[1]);
          // print(current[2]);
          // print(current[3]);
          // print(tempDate);
          // print(current[5]);
          // print(current[6]);
          tempList.add(Project.create(current[1], current[2], current[3], tempDate, current[5], int.parse(current[6])));
          // print("project processed");
        } else if (current[0].contains("content")){
          //add content to latest project
          //print("content found");
          DateTime tempDate = DateTime(int.parse(current[5].substring(0,4)), int.parse(current[5].substring(5,7)), int.parse(current[5].substring(8,10)));
          //print("dateTime processed");
          // print(current[1]);
          // print(current[2]);
          // print(current[3]);
          // print(current[4]);
          // print(tempDate);
          // print(current[6]);
          // print(current[7]);
          Content newContent = Content.create(current[1], current[2], current[3], current[4], tempDate, current[6], int.parse(current[7]));
          //Resets content streak if there is any incomplete content.
          if(newContent.getStatus().contains("Incomplete")){
            stats.contentStreak = 0;
          }
          // print("content made");
          tempList[tempList.length-1].addContent(newContent);
          //print(projectIndex);
          //print ("Content Processed");
          //print(newContent.toCSV());
        }
        //print(tempList[i].toCSV());
      }
      // print("project List complete");
      // for(int i=0; i<tempList.length; i++){
      //   print(tempList[i].toCSV());
      // }
      projectList = tempList;

      // for(int i=0; i<projectList.length; i++){
      //   print(projectList[i].toCSV());
      // }

      return 0;
    } catch (e) {
      // If encountering an error, return 1
      return 1;
    }
  }

//saves the current shopList to a file
  Future<File> saveShop() async{
    final file = await _itemsFile;
    for (int i=0; i < shopList.length; i++){
      if (i==0) {
        file.writeAsStringSync("${shopList[i].toCSV()}\n"); //erases all old data and starts fresh
      } else {
        file.writeAsStringSync("${shopList[i].toCSV()}\n", mode: FileMode.append); //appends to current
      }
    }
    return file;
  }

//loads a shopList from a file
  Future<int> loadShop() async {
    try {
      final file = await _itemsFile;

      // Read the file
      final contents = await file.readAsLines();

      //Create temp projectList
      var tempList = <ShopItem>[];

      // Create Projects/Content for each
      for (int i=0; i<contents.length; i++){
        var current = contents[i].split(',,');
        tempList.add(ShopItem(current[0], int.parse(current[1]), current[2], current[3]));
      }
      shopList = tempList;
      return 0;
    } catch (e) {
      // If encountering an error, return 1
      return 1;
    }
  }

//saves the current stats to a file
  Future<File> saveStats() async{
    final file = await _statsFile;
    file.writeAsStringSync(stats.toCSV());
    return file;
  }

//loads stats from a file
  Future<int> loadStats() async {
    try {
      final file = await _statsFile;

      // Read the file
      final contents = await file.readAsString();
      var statList = contents.split(',');
      Stats tempStats = Stats(int.parse(statList[0]), int.parse(statList[1]), int.parse(statList[2]), int.parse(statList[3]), int.parse(statList[4]), int.parse(statList[5]), int.parse(statList[6]), int.parse(statList[7]), int.parse(statList[8]), int.parse(statList[9]), int.parse(statList[10]), int.parse(statList[11]));
      stats = tempStats;
      return 0;
    } catch (e) {
      // If encountering an error, return 1
      return 1;
    }
  }

  //Sort projects by release date
  void sortProjects(){
    for (int i = 1; i < projectList.length; i++) {
      int j = i;

      while (j > 0 && projectList[j].getReleaseDate().isBefore(projectList[j-1].getReleaseDate())) {
        Project aux = projectList[j];
        projectList[j] = projectList[j - 1];
        projectList[j - 1] = aux;
        j--;
      }
    }
  }

  //Sort shop items by cost
  void sortItems(){

  }

  //Create Project stat update
  void createProject(int contentAmount){
    stats.contentCreated += contentAmount;
    stats.projectsCreated += 1;
  }

  //Delete Project stat update
  void deleteProject(int contentAmount){

  }

  //Earn Coins
  void earnCoins(int amount){
    int total = (amount*stats.coinMultiplier).toInt();
    stats.coins += total;
    stats.coinsEarned += total;
  }

  //Spend Coins
  void spendCoins(int amount){
    stats.coins -= amount;
    stats.coinsSpent += amount;
  }

  //Complete Content
  void completeContent(){
    stats.contentCompleted += 1;
    stats.contentStreak += 1;
    stats.longestStreak = max(stats.contentStreak, stats.longestStreak);
    stats.updateMultiplier();
  }

  //Cancel Content
  void cancelContent(){
    stats.contentFailed += 1;
    stats.contentStreak = 0;
    stats.updateMultiplier();
  }

  //Save to flutter database
  Future<void> saveToFirebase() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    File projectsFileIn = await _projectsFile;
    File itemsFileIn = await _itemsFile;
    File statsFileIn = await _statsFile;

    // Location to save file to
    String projectsLocation = "userdata/" + uid + "/" + "savedProjects.csv";
    String itemsLocation = "userdata/" + uid + "/" + "savedItems.csv";
    String statsLocation = "userdata/" + uid + "/" + "savedStats.txt";

    print("Project Location: " + projectsLocation);
    print("Item Location: " + itemsLocation);
    print("Stat Location: " + statsLocation);

    // Create a storage reference from our app
    final projectsRef = storageRef.ref(projectsLocation);
    final itemsRef = storageRef.ref(itemsLocation);
    final statsRef = storageRef.ref(statsLocation);

    try {
      await projectsRef.putFile(projectsFileIn);
      await itemsRef.putFile(itemsFileIn);
      await statsRef.putFile(statsFileIn);
    } catch (e){
      print("Error in saving to cloud.");
      print(e.toString());
    }
  }

  //Load from firebase database
  Future<void> loadFromFirebase() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    File projectsFileIn = await _projectsFile;
    File itemsFileIn = await _itemsFile;
    File statsFileIn = await _statsFile;

    // Location to load files from
    String projectsLocation = "userdata/" + uid + "/" + "savedProjects.csv";
    String itemsLocation = "userdata/" + uid + "/" + "savedItems.csv";
    String statsLocation = "userdata/" + uid + "/" + "savedStats.txt";

    // Create a storage reference from our app
    final projectsRef = storageRef.ref(projectsLocation);
    final itemsRef = storageRef.ref(itemsLocation);
    final statsRef = storageRef.ref(statsLocation);

    try {
      await projectsRef.writeToFile(projectsFileIn);
      await itemsRef.writeToFile(itemsFileIn);
      await statsRef.writeToFile(statsFileIn);
      //_projectsFile = projectsFileIn as Future<File>;

      //note for future me: you need to modify the load function to be able to take non-future files as well
      //note for future me: take a break, bitch
    } catch (e){
      print("Error in loading from cloud.");
      print(e.toString());
    }


    loadAll();
  }

}