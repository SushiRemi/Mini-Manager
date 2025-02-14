class ShopItem{
  String name = "";
  int cost = 0;
  String description = "";
  String icon = "";

  ShopItem(String nameIn, int costIn, String descriptionIn, String iconIn){
    name = nameIn;
    cost = costIn;
    description = descriptionIn;
    icon = iconIn;
  }

  String getName(){
    return name;
  }

  void setName(String newName){
    name = newName;
  }

  int getCost(){
    return cost;
  }

  void setCost(int newCost){
    cost = newCost;
  }

  String getDescription(){
    return description;
  }

  void setDescription(String newDescription){
    description = newDescription;
  }

  String getIcon(){
    return icon;
  }

  void setIcon(String newIcon){
    icon = newIcon;
  }

  String toCSV(){
    String out = "";
    out += ("\"$name\",,");
    out += ("$cost,,");
    out += ("\"$description\",,");
    out += ("\"$icon\"");
    return out;
  }
}