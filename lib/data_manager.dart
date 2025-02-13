//connecting to other pages
import 'package:mini_manager/project.dart';
import 'package:mini_manager/shopitem.dart';

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
  var stats = <int>[]; //includes coin amount


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
    file.writeAsStringSync("hello");
    file.writeAsStringSync(" universe!", mode: FileMode.append);
    return file;
  }

//loads a projectList from a file
  void loadProjects(){

  }

//saves the current shopList to a file
  void saveShop(){

  }

//loads a shopList from a file
  void loadShop(){

  }

//saves the current stats to a file
  void saveStats(){

  }

//loads stats from a file
  void loadStats(){

  }
}