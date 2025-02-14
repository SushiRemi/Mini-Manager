class Content{
  String title = "";
  String type = "";
  String description = "";
  //String date = "";
  DateTime date = DateTime(0,0,0);
  String status = "";
  //List<String> tags = [];

  Content.empty(){
    title = "";
    type = "";
    description = "";
    date = DateTime(0,0,0);
    status = "";
    //tags = [];
  }

  Content.create(String titleIn, String typeIn, String descriptionIn, DateTime dateIn, String statusIn){
    title = titleIn;
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

  DateTime getDate(){
    return date;
  }

  void setDate(DateTime newDate){
    date = newDate;
  }

  String getStatus(){
    return status;
  }

  void setStatus(String newStatus){
    status = newStatus;
  }

  /*
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
  */


  String toCSV(){
    String out = "";
    out += "\"content\",,";
    out += "\"$title\",,";
    out += "\"$type\",,";
    out += "\"$description\",,";
    out += (date.toString().substring(0, 10));
    out += ",,\"$status\"";
    return out;
  }
}



