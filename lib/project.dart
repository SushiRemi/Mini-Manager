import 'content.dart';

class Project{
  String title = "";
  String type = "";
  String description = "";
  DateTime startDate = DateTime(0,0,0);
  DateTime endDate = DateTime(0,0,0);
  String status = "";
  List<Content> contentList = [];
  //List<String> tags = [];


  Project.empty(){
    title = "";
    type = "";
    description = "";
    startDate = DateTime(0,0,0);
    endDate = DateTime(0,0,0);
    status = "";
    contentList = [];
    //tags = [];
  }

  Project.create(String titleIn, String typeIn, String descriptionIn, DateTime startDateIn, DateTime endDateIn, String statusIn){
    title = titleIn;
    type = typeIn;
    description = descriptionIn;
    startDate = startDateIn;
    endDate = endDateIn;
    status = statusIn;

    //initialize contentList with the content needed based on the project type (Album, EP, Single, Other)
    switch (type){
      case "Album":

      case "EP":

      case "Single":

      case "Other":

      default:
    }
  }

  String getTitle(){
    return title;
  }

  void setTitle(String newTitle){
    title = newTitle;
  }

  String getType(){
    return type;
  }

  void setType(String newType){
    type = newType;
  }

  String getDescription(){
    return description;
  }

  void setDescription(String newDescription){
    description = newDescription;
  }

  DateTime getStartDate(){
    return startDate;
  }

  void setStartDate(DateTime newStartDate){
    startDate = newStartDate;
  }

  DateTime getEndDate(){
    return endDate;
  }

  void setEndDate(DateTime newEndDate){
    endDate = newEndDate;
  }

  String getStatus(){
    return status;
  }

  void setStatus(String newStatus){
    status = newStatus;
  }

  Content getContent(int index){
    return contentList[index];
  }

  void addContent(Content c){
    //check for duplicates
    contentList.add(c);
  }

  void removeContent(int index){
    //check if it exists
    contentList.removeAt(index);
  }

  String toCSV(){
    String out = "";
    out += "\"project\",";
    out += "\"$title\",";
    out += "\"$type\",";
    out += "\"$description\",";
    out += (startDate.toString().substring(0, 10));
    out += ",";
    out += (endDate.toString().substring(0, 10));
    out += ",";
    out += "\"$endDate\",";
    out += "\"$status\"";
    return out; //contentList csv is handled by the content toCSV() function
  }

  void sortContentByDate(){ //untested insertion sort, will need version for sorting projects.
    for (int i = 1; i < contentList.length; i++) {
      int j = i;

      while (j > 0 && contentList[j].getDate().isBefore(contentList[j-1].getDate())) {
        Content aux = contentList[j];
        contentList[j] = contentList[j - 1];
        contentList[j - 1] = aux;
        j--;
      }
    }
  }
}

