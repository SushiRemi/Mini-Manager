class Content{
  String title = "";
  int parentProjectID = -1;
  String type = "";
  String description = "";
  String date = "";
  String status = "";
  List<String> tags = [];

  Content.empty(){
    title = "";
    parentProjectID = -1;
    type = "";
    description = "";
    date = "";
    status = "";
    tags = [];
  }

  Content.create(String titleIn, int projectIDIn, String typeIn, String descriptionIn, String dateIn, String statusIn){
    title = titleIn;
    parentProjectID = projectIDIn;
    type = typeIn;
    description = descriptionIn;
    date = dateIn;
    status = statusIn;

  }

  String getTitle(){
    return title;
  }

  void setTitle(String newTitle){
    title = newTitle;
  }

  int getParentProjectID(){
    return parentProjectID;
  }

  void setProjectID(int newID){
    parentProjectID = newID;
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

  String getDate(){
    return date;
  }

  void setDate(String newDate){
    date = newDate;
  }

  String getStatus(){
    return status;
  }

  void setStatus(String newStatus){
    status = newStatus;
  }

  List<String> getTags(){
    return tags;
  }

  void addTag(String newTag){
    //need to check for duplicates
    tags.add(newTag);
  }

  void removeTag(int index){
    //check if exists
    tags.removeAt(index);
  }
}



