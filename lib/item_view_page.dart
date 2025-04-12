import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_manager/data_manager.dart';
import 'package:mini_manager/project.dart';
import 'package:mini_manager/projects_page.dart';

//used for info text
import 'package:expandable_text/expandable_text.dart';
import 'package:mini_manager/shop_page.dart';
import 'package:mini_manager/shopitem.dart';

import 'edit_item_page.dart';

class ItemViewPage extends StatefulWidget {
  const ItemViewPage({super.key, required this.title, required this.index, required this.name, required this.description, required this.cost, required this.icon});

  final String title;
  final int index;
  final String name;
  final String description;
  final int cost;
  final Icon icon;

  @override
  State<ItemViewPage> createState() => _ItemViewPage(index, name, description, cost, icon);
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

class _ItemViewPage extends State<ItemViewPage> {
  DataManager data = DataManager();

  //for project creation
  String pTitle = "";
  String pDescription = "";
  Icon pIcon = Icon(Icons.favorite, size: 50, color: Colors.red,);
  int pCost = -1;
  DateTime pReleaseDate = DateTime(0);
  int index = -1;
  Color iconColor = Colors.orange;
  double iconSize = 200;
  int coins = 0;
  String iconName = "Favorite";

  _ItemViewPage(int index, String title, String description, int cost, Icon icon){
    data.loadAll();
    this.index = index;
    pTitle = title;
    pDescription = description;
    pCost = cost;
    pIcon = Icon(icon.icon, color: iconColor, size: iconSize);
    coins = data.stats.coins;
  }

  //save projects to file
  void _save() {
    data.saveShop();
  }

  //load projects from file
  void _load() {
    data.loadShop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //data.loadShop();
    Timer(const Duration(milliseconds: 100), () => setState(() {
      coins = data.stats.coins;
      iconName = data.shopList[index].getIcon();
    }));
  }

  @override
  Widget build(BuildContext context) {
    _load();


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("assets/coins.png"),
                width: 40,
                height: 40,
              ),
              Text(
                coins.toString() + "     ",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              )
            ],
          )

        ],
      ),
      body: Center(
          child: Flex(
            direction: Axis.vertical,
            children: [
              //Item Details
              Container(
                color: Colors.black,
                margin: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 4.0),
                padding: const EdgeInsets.all(0.0),
                child:
                Container(
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(5.0),
                  //width: 400,
                    color: Colors.blue,
                    child:
                    Column(
                        children: [
                          Text(
                            pTitle,
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          pIcon,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                image: AssetImage("assets/coins.png"),
                                width: 40,
                                height: 40,
                              ),
                              Text(
                                pCost.toString(),
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )
                        ]
                    )
                )
              ),

              //Item Description
              Text(
                pDescription,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.black,

                ),
              ),

              //Row with buy/edit item
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: (){
                      //Buy Item
                      print("Item Buy Attempt");
                      if(data.stats.coins < pCost){
                        print("Not enough coins");
                        showDialog<String>(
                          context: context,
                          builder:
                              (BuildContext context) => AlertDialog(
                            title: const Text('Not Enough Coins!'),
                            content: Text('You do not have enough coins to buy this item!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Ok'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        print("buy alert here");
                        showDialog<String>(
                          context: context,
                          builder:
                              (BuildContext context) => AlertDialog(
                            title: const Text('Buy Item?'),
                            content: Text('Are you sure you want to buy $pTitle? You can not refund an item once purchased.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  print("Button Pressed");
                                  data.spendCoins(pCost);
                                  data.saveStats();
                                  Navigator.pop(context, 'Bought');
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        title: const Text('Item Bought!'),
                                        content: Text('You bought $pTitle on ' + DateTime.now().month.toString() + "/" + DateTime.now().day.toString() + "/" + DateTime.now().year.toString() + "!\nTake a screenshot to record your purchase!"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pushAndRemoveUntil(
                                                  MaterialPageRoute(builder: (context) => const ShopPage(title: "Shop")),
                                                  ModalRoute.withName("Shop")
                                              );
                                            },
                                            child: const Text('Back to shop'),
                                          )
                                        ],
                                      )
                                  );
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );

                    }
                      },
                    child:
                      Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(5.0),
                        color: Colors.black,
                        child:
                        Container(
                          margin: const EdgeInsets.all(0.0),
                          padding: const EdgeInsets.all(5.0),
                          color: Colors.deepPurple,
                          child: Text(
                            "Buy Item",
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          ),
                        )
                      )

                  ),
                  //Edit item button
                  TextButton(
                      onPressed: (){
                        //
                        print("Edit Item");
                        print(iconName);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => EditItemPage(title: "Edit Item", index: index, name: pTitle, description: pDescription, iconName: iconName, cost: pCost,)),
                        );
                      },
                      child:
                      Container(
                          margin: const EdgeInsets.all(0.0),
                          padding: const EdgeInsets.all(5.0),
                          color: Colors.black,
                          child:
                          Container(
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.all(5.0),
                            color: Colors.deepPurple,
                            child: Text(
                              "Edit Item",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                          )
                      )

                  ),
                ],
              )
            ],
          )
      ),
    );
  }
}
