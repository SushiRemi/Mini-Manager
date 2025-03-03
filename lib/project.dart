import 'content.dart';

class Project{
  String _title = "";
  String _type = "";
  String _description = "";
  DateTime _releaseDate = DateTime(0,0,0);
  String _status = "";
  int _coinValue = 0;
  List<Content> _contentList = [];


  Project.empty(){
    _title = "";
    _type = "";
    _description = "";
    _releaseDate = DateTime(0,0,0);
    _status = "";
    _coinValue = 0;
    _contentList = [];
  }

  Project.create(String titleIn, String typeIn, String descriptionIn, DateTime releaseDateIn, String statusIn, int coinValueIn){
    _title = titleIn;
    _type = typeIn;
    _description = descriptionIn;
    _releaseDate = releaseDateIn;
    _status = statusIn;
    _coinValue = coinValueIn;

    //loading in the content list is handled by the data manager
  }

  Project.createNew(String titleIn, String typeIn, String descriptionIn, DateTime releaseDateIn, int mainContentIn){
    _title = titleIn;
    _type = typeIn.toLowerCase();
    _description = descriptionIn;
    _releaseDate = releaseDateIn;
    _status = "in progress";
    _coinValue = 0;
    int contentNum = mainContentIn;
    int daysBetween = 3;

    //Coin values for video types
    int smallCoinValue = 20;
    int mediumCoinValue = 50;
    int largeCoinValue = 100;

    //Calculate daysBetween
    int dayRange = findDayRange(DateTime.now(), _releaseDate);
    bool valid = false;
    while (!valid && daysBetween > 0){
      if (dayRange > 3*contentNum * (daysBetween+1)){
        valid = true;
      } else {
        daysBetween -= 1;
      }
    }

    //initialize contentList with the content needed based on contentNum, _releaseDate, and _daysBetween
    //Creating the post-release content
    int postReleaseContent = 0;
    switch (_type){
      case "album":
        postReleaseContent = 4;
        break;
      case "ep":
        postReleaseContent = 3;
        break;
      case "single":
        postReleaseContent = 2;
        break;
      case "other":
        postReleaseContent = 2;
        break;
      default:
        postReleaseContent = 2;
        break;
    }

    DateTime contentDate = _releaseDate;
    for (int i=0; i<postReleaseContent; i++){
      int num = i+1;
      contentDate.add(Duration(days: daysBetween+1));
      _contentList.add(Content.create("Post-Release $num", _title, "video", "", contentDate, "in progress", smallCoinValue));
    }

    //Creating Main release
    contentDate = _releaseDate;
    _contentList.add(Content.create("Project: $_title - Release Day", _title, "video", "", contentDate, "in progress", largeCoinValue));

    //Creating the pre-release content
    int daysBack = (daysBetween + 1) * 3 * contentNum;
    contentDate.subtract(Duration(days: daysBack)); //back at beginning now
    for (int i = 0; i < contentNum; i++){
      int num = i+1;
      _contentList.add(Content.create("Main Content $num - Pre-Release 1", _title, "video", "", contentDate, "in progress", smallCoinValue));
      contentDate.add(Duration(days: daysBetween + 1));
      _contentList.add(Content.create("Main Content $num - Pre-Release 2", _title, "video", "", contentDate, "in progress", smallCoinValue));
      contentDate.add(Duration(days: daysBetween + 1));
      _contentList.add(Content.create("Main Content $num - Release Day", _title, "video", "", contentDate, "in progress", mediumCoinValue));
      contentDate.add(Duration(days: daysBetween + 1));
    }

    //Sort content
    sortContentByDate();
    
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

  DateTime getReleaseDate(){
    return _releaseDate;
  }

  void setReleaseDate(DateTime newStartDate){
    _releaseDate = newStartDate;
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
    out += (_releaseDate.toString().substring(0, 10));
    out += ",,";
    out += "\"$_status\"";

    //handle content
    for (int i=0; i<_contentList.length; i++){
      out += "\n";
      out += _contentList[i].toCSV();
    }
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

  int findDayRange(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}

