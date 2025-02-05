import 'content.dart';

class Project{
  String title = "";
  int projectID = -1;
  String type = "";
  String description = "";
  String startDate = "";
  String endDate = "";
  String status = "";
  List<Content> contentList = [];
  List<String> tags = [];


  Project.empty(){
    title = "";
    projectID = -1;
    type = "";
    description = "";
    startDate = "";
    endDate = "";
    status = "";
    contentList = [];
    tags = [];
  }

  Project.create(String titleIn, int projectIDIn, String typeIn, String descriptionIn, String startDateIn, String endDateIn, String statusIn){
    title = titleIn;
    projectID = projectIDIn;
    type = typeIn;
    description = descriptionIn;
    startDate = startDateIn;
    endDate = endDateIn;
    status = statusIn;

    //initialize contentList with the content needed based on the project type (Album, EP, Single, Other)
  }

  String getTitle(){
    return title;
  }

  void setTitle(String newTitle){
    title = newTitle;
  }

  int getProjectID(){
    return projectID;
  }

  void setProjectID(int newID){
    projectID = newID;
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

  String getStartDate(){
    return startDate;
  }

  void setStartDate(String newStartDate){
    startDate = newStartDate;
  }

  String getEndDate(){
    return endDate;
  }

  void setEndDate(String newEndDate){
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

}

