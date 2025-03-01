import 'package:mini_manager/project.dart';

class Content{
  String _title = "";
  String _parent = "";
  String _type = "";
  String _description = "";
  //String date = "";
  DateTime _date = DateTime(0,0,0);
  String _status = "";
  //List<String> tags = [];
  int _coinValue = 0;

  Content.empty(){
    _title = "";
    _parent = "";
    _type = "";
    _description = "";
    _date = DateTime(0,0,0);
    _status = "";
    //tags = [];
    _coinValue = 0;
  }

  Content.create(String titleIn, String parentIn, String typeIn, String descriptionIn, DateTime dateIn, String statusIn, int coinValueIn){
    _title = titleIn;
    _parent = parentIn;
    _type = typeIn;
    _description = descriptionIn;
    _date = dateIn;
    _status = statusIn;
    _coinValue = coinValueIn;

  }

  String getTitle(){
    return _title;
  }

  void setTitle(String newTitle){
    _title = newTitle;
  }

  String getType(){
    return _type;
  }

  void setType(String newType){
    _type = newType;
  }

  String getDescription(){
    return _description;
  }

  void setDescription(String newDescription){
    _description = newDescription;
  }

  DateTime getDate(){
    return _date;
  }

  void setDate(DateTime newDate){
    _date = newDate;
  }

  String getStatus(){
    return _status;
  }

  void setStatus(String newStatus){
    _status = newStatus;
  }

  int getCoinValue(){
    return _coinValue;
  }

  void setCoinValue(int newCoinValue){
    _coinValue = newCoinValue;
  }

  String getParent(){
    return _parent;
  }

  void setParent(Project project){
    _parent = project.getTitle();
  }


  String toCSV(){
    String out = "";
    out += "\"content\",,";
    out += "\"$_title\",,";
    out += "\"$_parent\",,";
    out += "\"$_type\",,";
    out += "\"$_description\",,";
    out += (_date.toString().substring(0, 10));
    out += ",,\"$_status\"";
    return out;
  }
}



