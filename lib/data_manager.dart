//connecting to other pages
import 'package:mini_manager/project.dart';
import 'package:mini_manager/shopitem.dart';
import 'package:mini_manager/content.dart';
import 'package:mini_manager/stats.dart';

//imports for saving/loading files
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

class DataManager {
  //Initialize DataManager
  DataManager();

  //Lists of projects, items, and other stats tracked throughout program life
  var projectList = <Project>[];
  var shopList = <ShopItem>[];
  var stats = Stats(0,0,0,0,0,0,0,0,0,0,0,0); //includes coin amount


  //_localPath is where we store files on the devices.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _projectsFile async {
    final path = await _localPath;
    return File('$path/savedProjects.csv');
  }

  Future<File> get _itemsFile async {
    final path = await _localPath;
    return File('$path/savedItems.csv');
  }

  Future<File> get _statsFile async {
    final path = await _localPath;
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


  String getPath(){
    return _localPath.toString();
  }

//saves the current projectList to a file
  Future<File> saveProjects() async{
    final file = await _projectsFile;
    for (int i=0; i < projectList.length; i++){
      if (i==0) {
        file.writeAsStringSync("${projectList[i].toCSV()}\n"); //erases all old data and starts fresh
      } else {
        file.writeAsStringSync("${projectList[i].toCSV()}\n", mode: FileMode.append); //appends to current
      }
    }
    //file.writeAsStringSync("hello");
    //file.writeAsStringSync(" universe!", mode: FileMode.append);
    return file;
  }

//loads a projectList from a file
  Future<int> loadProjects() async {
    try {
      final file = await _projectsFile;

      // Read the file
      final contents = await file.readAsLines();

      //Create temp projectList
      var tempList = <Project>[];

      // Create Projects/Content for each
      for (int i=0; i<contents.length; i++){
        var current = contents[i].split(',,');
        if(current[0].contains("project")){
          DateTime tempStart = DateTime(int.parse(current[4].substring(0,4)), int.parse(current[4].substring(5,7)), int.parse(current[4].substring(8,10)));
          DateTime tempEnd = DateTime(int.parse(current[5].substring(0,4)), int.parse(current[5].substring(5,7)), int.parse(current[5].substring(8,10)));
          tempList.add(Project.create(current[1], current[2], current[3], tempStart, tempEnd, current[6]));
        } else if (current[0].contains("content")){
          //add content to latest project
          DateTime tempDate = DateTime(int.parse(current[4].substring(0,4)), int.parse(current[4].substring(5,7)), int.parse(current[4].substring(8,10)));
          Content newContent = Content.create(current[1], current[2], current[3], tempDate, current[5], int.parse(current[6]));
          tempList[tempList.length-1].addContent(newContent);
        }
      }
      projectList = tempList;
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
}