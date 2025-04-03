import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_manager/data_manager.dart';
import 'package:mini_manager/project.dart';
import 'package:mini_manager/projects_page.dart';

//used for info text
import 'package:expandable_text/expandable_text.dart';
import 'package:mini_manager/shop_page.dart';
import 'package:mini_manager/shopitem.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({super.key, required this.title, required this.index, required this.name, required this.description, required this.iconName, required this.cost});

  final String title;
  final int index;
  final String name;
  final String description;
  final String iconName;
  final int cost;

  @override
  State<EditItemPage> createState() => _EditItemPage(index, name, description, iconName, cost);
}

//DropdownMenuEntry labels and values for project type dropdown menu
typedef IconEntry = DropdownMenuEntry<IconLabel>;
const double iconSize = 50;
const Color iconColor = Colors.black;

enum IconLabel {

  //select('Select', "select"),
  shopping('Shopping', Icon(Icons.shopping_bag, size: iconSize, color: iconColor,)),
  drink('Drink', Icon(Icons.coffee, size: iconSize, color: iconColor,)),
  food('Food', Icon(Icons.fastfood, size: iconSize, color: iconColor,)),
  social('Social', Icon(Icons.emoji_people, size: iconSize, color: iconColor,)),
  art('Art', Icon(Icons.brush, size: iconSize, color: iconColor,)),
  music('Music', Icon(Icons.piano, size: iconSize, color: iconColor,)),
  movie('Movie', Icon(Icons.local_movies, size: iconSize, color: iconColor,)),
  electronics('Electronics', Icon(Icons.computer, size: iconSize, color: iconColor,)),
  ticket('Ticket', Icon(Icons.confirmation_num_outlined, size: iconSize, color: iconColor,)),
  game('Game', Icon(Icons.videogame_asset_rounded, size: iconSize, color: iconColor,)),
  book('Book', Icon(Icons.book, size: iconSize, color: iconColor,)),
  trip('Trip', Icon(Icons.airplanemode_on, size: iconSize, color: iconColor,)),
  favorite('Favorite', Icon(Icons.star, size: iconSize, color: iconColor,)),
  heart('Heart', Icon(Icons.favorite, size: iconSize, color: iconColor,)),
  other('Other', Icon(Icons.question_mark, size: iconSize, color: iconColor,));

  const IconLabel(this.label, this.value);
  final String label;
  final Icon value;

  static final List<IconEntry> entries = UnmodifiableListView<IconEntry>(
    values.map<IconEntry>(
          (IconLabel icon) => IconEntry(
        value: icon,
        leadingIcon: icon.value,
        label: icon.label,
        //enabled: type.label != 'Select',
        style: MenuItemButton.styleFrom(foregroundColor: Colors.black),
      ),
    ),
  );
}

class _EditItemPage extends State<EditItemPage> {
  DataManager data = DataManager();

  //for item creation
  String pTitle = "";
  String pDescription = "";
  Icon pIcon = Icon(Icons.favorite, size: iconSize, color: iconColor,);
  String pIconName = "Favorite";
  int pCost = -1;
  DateTime pReleaseDate = DateTime(0);
  int index = -1;
  IconLabel icon = IconLabel.favorite;

  _EditItemPage(int index, String name, String description, String iconName, int cost){
    this.index = index;
    pTitle = name;
    pDescription = description;
    pIconName = iconName;
    pCost = cost;
    print(pIconName);
    switch(pIconName) {
      case "Shopping":
        icon = IconLabel.shopping;
        pIcon = Icon(Icons.shopping_bag, size: iconSize, color: iconColor,);
        break;
      case "Drink":
        icon = IconLabel.drink;
        pIcon = Icon(Icons.coffee, size: iconSize, color: iconColor,);
        break;
      case "Food":
        icon = IconLabel.food;
        pIcon = Icon(Icons.fastfood, size: iconSize, color: iconColor,);
        break;
      case "Social":
        icon = IconLabel.social;
        pIcon = Icon(Icons.emoji_people, size: iconSize, color: iconColor,);
        break;
      case "Art":
        icon = IconLabel.art;
        pIcon = Icon(Icons.brush, size: iconSize, color: iconColor,);
        break;
      case "Music":
        icon = IconLabel.music;
        pIcon = Icon(Icons.piano, size: iconSize, color: iconColor,);
        break;
      case "Movie":
        icon = IconLabel.movie;
        pIcon = Icon(Icons.local_movies, size: iconSize, color: iconColor,);
        break;
      case "Electronics":
        icon = IconLabel.electronics;
        pIcon = Icon(Icons.computer, size: iconSize, color: iconColor,);
        break;
      case "Ticket":
        icon = IconLabel.ticket;
        pIcon = Icon(Icons.confirmation_num_outlined, size: iconSize, color: iconColor,);
        break;
      case "Game":
        icon = IconLabel.game;
        pIcon = Icon(Icons.videogame_asset_rounded, size: iconSize, color: iconColor,);
        break;
      case "Book":
        icon = IconLabel.book;
        pIcon = Icon(Icons.book, size: iconSize, color: iconColor,);
        break;
      case "Trip":
        icon = IconLabel.trip;
        pIcon = Icon(Icons.airplanemode_on, size: iconSize, color: iconColor,);
        break;
      case "Favorite":
        icon = IconLabel.favorite;
        pIcon = Icon(Icons.star, size: iconSize, color: iconColor,);
        break;
      case "Heart":
        icon = IconLabel.heart;
        pIcon = Icon(Icons.favorite, size: iconSize, color: iconColor,);
        break;
      case "Other":
        icon = IconLabel.other;
        pIcon = Icon(Icons.question_mark, size: iconSize, color: iconColor,);
        break;
      default:
        icon = IconLabel.other;
        pIcon = Icon(Icons.question_mark, size: iconSize, color: iconColor,);
        break;
    }
  }

  //save projects to file
  void _save() {
    data.saveShop();
  }

  //load projects from file
  void _load() {
    data.loadShop();
  }

  //Attempt to create new project
  void _submitItem(){
    print("Title: $pTitle");
    print("Description: $pDescription");
    print("Icon: $pIconName");
    print("Cost: $pCost");
    print("SUBMITTED");

    //Check if enough info is filled out
    if(pTitle != "" && pCost >= 0){
      print("VALID");
      //Create and save into data, then destroy page and go back to projects.
      //ShopItem newItem = ShopItem(pTitle, pCost, pDescription, pIconName);
      //data.shopList.add(newItem);
      data.shopList[index].name = pTitle;
      data.shopList[index].cost = pCost;
      data.shopList[index].description = pDescription;
      data.shopList[index].icon = pIconName;

      _save();
      data.saveToFirebase();
      print("Item sent to data manager");

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ShopPage(title: "Shop Page")),
          ModalRoute.withName("Shop Page")
      );

      // Timer(const Duration(seconds: 3), () => Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => const ShopPage(title: "Shop Page")),
      //     ModalRoute.withName("Shop Page")
      // ));



    } else {
      print("INVALID");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //data.loadShop();
  }

  @override
  Widget build(BuildContext context) {
    _load();


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView(
            children: [
              //Title Field
              Container(
                  color: Colors.pinkAccent,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Item Name: ",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                          ),

                        ),
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          initialValue: pTitle,
                          onChanged: (String value){
                            pTitle = value; //set pTitle for project creation
                          },
                        )
                      ]
                  )
              ),
              //Description Field
              Container(
                  color: Colors.pinkAccent,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Project Description: ",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                          ),

                        ),
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          initialValue: pDescription,
                          onChanged: (String value) {
                            pDescription = value;
                          },
                          maxLines: null,
                        )
                      ]
                  )
              ),
              //Item Icon Field/Item Cost Field
              Container(
                  color: Colors.lightBlue,
                  child: Row(
                      children: [
                        //Project Type
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Item Icon: ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                DropdownMenu(
                                  width: 200,
                                  dropdownMenuEntries: IconLabel.entries,
                                  initialSelection: icon,
                                  leadingIcon: pIcon,
                                  onSelected: (IconLabel? selectedType){
                                    setState(() {
                                      pIconName = selectedType!.label;
                                      pIcon = selectedType.value;
                                    });
                                  },
                                ),
                              ]
                          ),
                        ),

                        //Item Cost
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Item Cost: ",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                TextFormField(
                                  //groupId: project.getContentList().length,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    initialValue: pCost.toString(),
                                    onChanged: (String value) {
                                      if(value.isEmpty){
                                        pCost = -1;
                                      } else {
                                        pCost = int.parse(value);
                                      }
                                    }
                                )
                              ]
                          ),
                        ),
                      ]
                  )

              ),
              //Recommended Item Costs
              Text(
                "Recommended Cost Values:",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              Text(
                "Small Item - 20 to 90 coins\n"
                    "Medium Item - 100 to 400 coins\n"
                    "Large Item - 400 to 1000 coins\n"
                    "Huge Item - 1000+ coins",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              //Submit Button
              TextButton(
                style: const ButtonStyle(
                    textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(
                      fontSize: 33,
                      color: Colors.purple,
                    ))
                ),
                onPressed: (){
                  _submitItem();
                },
                child: const Text(
                  "Save Item",
                ),
              ),
            ],
          )
      ),
    );
  }
}
