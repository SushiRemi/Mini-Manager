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

class NewItemPage extends StatefulWidget {
  const NewItemPage({super.key, required this.title, required this.index});

  final String title;
  final int index;

  @override
  State<NewItemPage> createState() => _NewItemPage();
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

class _NewItemPage extends State<NewItemPage> {
  DataManager data = DataManager();

  //for project creation
  String pTitle = "";
  String pDescription = "";
  Icon pIcon = Icon(Icons.favorite, size: iconSize, color: iconColor,);
  String pIconName = "Favorite";
  int pCost = -1;
  DateTime pReleaseDate = DateTime(0);


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
      ShopItem newItem = ShopItem(pTitle, pCost, pDescription, pIconName);
      data.shopList.add(newItem);
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
                  color: Colors.blue,
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
                        TextField(
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          onChanged: (String value){
                            pTitle = value; //set pTitle for project creation
                          },
                        )
                      ]
                  )
              ),
              //Description Field
              Container(
                  color: Colors.blue,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Item Description: ",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                          ),

                        ),
                        TextField(
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          onChanged: (String value) {
                            pDescription = value;
                          },
                          maxLines: null,
                        )
                      ]
                  )
              ),
              //Item Icon Field
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
                                  initialSelection: IconLabel.favorite,
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
                                TextField(
                                    //groupId: project.getContentList().length,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  "Create Item",
                ),
              ),
            ],
          )
      ),
    );
  }
}
