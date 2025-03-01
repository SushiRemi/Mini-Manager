import 'content.dart';

class Project{
  String _title = "";
  String _type = "";
  String _description = "";
  DateTime _startDate = DateTime(0,0,0);
  DateTime _endDate = DateTime(0,0,0);
  String _status = "";
  int _coinValue = 0;
  List<Content> _contentList = [];
  //List<String> tags = [];


  Project.empty(){
    _title = "";
    _type = "";
    _description = "";
    _startDate = DateTime(0,0,0);
    _endDate = DateTime(0,0,0);
    _status = "";
    _coinValue = 0;
    _contentList = [];
    //tags = [];
  }

  Project.create(String titleIn, String typeIn, String descriptionIn, DateTime startDateIn, DateTime endDateIn, String statusIn, int coinValueIn){
    _title = titleIn;
    _type = typeIn;
    _description = descriptionIn;
    _startDate = startDateIn;
    _endDate = endDateIn;
    _status = statusIn;
    _coinValue = coinValueIn;

    //initialize contentList with the content needed based on the project type (Album, EP, Single, Other)
    switch (_type){
      case "Album":

      case "EP":

      case "Single":

      case "Other":

      default:
    }
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

  DateTime getStartDate(){
    return _startDate;
  }

  void setStartDate(DateTime newStartDate){
    _startDate = newStartDate;
  }

  DateTime getEndDate(){
    return _endDate;
  }

  void setEndDate(DateTime newEndDate){
    _endDate = newEndDate;
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

  void setCoinValue(int coins){
    _coinValue = coins;
  }

  Content getContent(int index){
    return _contentList[index];
  }

  void addContent(Content c){
    //check for duplicates
    _contentList.add(c);
  }

  void removeContent(int index){
    //check if it exists
    _contentList.removeAt(index);
  }

  List<Content> getContentList(){
    return _contentList;
  }

  String toCSV(){
    String out = "";
    out += "\"project\",,";
    out += "\"$_title\",,";
    out += "\"$_type\",,";
    out += "\"$_description\",,";
    out += (_startDate.toString().substring(0, 10));
    out += ",,";
    out += (_endDate.toString().substring(0, 10));
    out += ",,";
    out += "\"$_status\"";
    return out; //contentList csv is handled by the content toCSV() function
  }

  void sortContentByDate(){ //untested insertion sort, will need version for sorting projects.
    for (int i = 1; i < _contentList.length; i++) {
      int j = i;

      while (j > 0 && _contentList[j].getDate().isBefore(_contentList[j-1].getDate())) {
        Content aux = _contentList[j];
        _contentList[j] = _contentList[j - 1];
        _contentList[j - 1] = aux;
        j--;
      }
    }
  }
}

