import 'package:flutter/material.dart';
import 'package:mini_manager/data_manager.dart';
import 'package:mini_manager/projects_page.dart';
import 'package:mini_manager/settings_stats_page.dart';
import 'package:mini_manager/shop_page.dart';
import 'package:mini_manager/calendar_page.dart';
import 'package:mini_manager/shopitem.dart';
import 'package:mini_manager/new_item_page.dart';

//used for swiping between pages
import 'package:go_router/go_router.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'go_router.dart';

enum NavigationMode{
  navigator,
  goRouter,
  goRouterBuilder;

  static const current = NavigationMode.navigator; //change this to switch between navigation modes
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key, required this.title});

  final String title;

  @override
  State<ShopPage> createState() => _ShopPage();
}

class _ShopPage extends State<ShopPage> {
  int _counter = 0;

  DataManager data = DataManager();

  //For dynamically displaying shop items
  List<Row> _itemWidgetList = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  //to update item widgets
  List<Row> _updateItemWidgetList(List<ShopItem> itemList){
    List<Row> newItemRowList = [];
    ItemWidget tempItem1 = ItemWidget.empty();
    ItemWidget tempItem2 = ItemWidget.empty();
    Row itemRow = new Row();
    int rowIndex = 0;

    //print(projectList.length);
    for(int i=0; i<itemList.length; i++){


      if(i%2 == 0){
        tempItem1 = ItemWidget(itemList[i], i);
      } else {
        tempItem2 = ItemWidget(itemList[i], i);
      }

      rowIndex++;

      if(rowIndex > 1 || (i+1) >= itemList.length){
        itemRow = Row(children: [tempItem1, tempItem2],);
        newItemRowList.add(itemRow);
        itemRow = new Row();
        rowIndex = 0;
        tempItem1 = ItemWidget.empty();
        tempItem2 = ItemWidget.empty();
      }
    }
    return newItemRowList;
  }

  //item widget list test function, debug function
  List<Row> _updateItemWidgetListTest(int items){
    List<Row> newItemRowList = [];
    ItemWidget tempItem1 = ItemWidget.empty();
    ItemWidget tempItem2 = ItemWidget.empty();
    Row itemRow = new Row();
    int rowIndex = 0;

    //print(projectList.length);
    for(int i=0; i<items; i++){


      if(i%2 == 0){
        tempItem1 = ItemWidget.test(i);
      } else {
        tempItem2 = ItemWidget.test(i);
      }

      rowIndex++;

      if(rowIndex > 1 || (i+1) >= items){
        itemRow = Row(children: [tempItem1, tempItem2],);
        newItemRowList.add(itemRow);
        itemRow = new Row();
        rowIndex = 0;
        tempItem1 = ItemWidget.empty();
        tempItem2 = ItemWidget.empty();
      }
    }
    return newItemRowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Coin Shop"),
      ),
      body: Center(
        child: Flex(
          direction: Axis.vertical,
          children: [
            //Create Item Button
            Expanded(
              flex: 0,
                child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.black12,
                          child:
                          Expanded(
                            child: TextButton(
                              onPressed: (){
                                data.saveAll();

                                // Change to new item page when ready
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => NewItemPage(title: "Add Item", index: -1,)),
                                );
                              },
                              child:
                              const Text(
                                "Create New Item",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]
                ),

            ),



            //Item List
            Expanded(
              flex: 6,
                child: ListView(
                  children: _itemWidgetList = _updateItemWidgetList(data.shopList),
                  //children: _itemWidgetList = _updateItemWidgetListTest(5),
                )
            ),
            //Bottom Nav Bar
            Expanded(
              flex: 1,
              child: BottomAppBar(
                color: Color(0xFF290238),
                shape: const CircularNotchedRectangle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Calendar Page
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => CalendarPage(title: "Calendar")),
                            ModalRoute.withName("Calendar")
                        );
                      },
                      icon: const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 75,
                          semanticLabel: 'Calendar Page'
                      ),
                    ),

                    //Project Page
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => ProjectsPage(title: "Projects")),
                            ModalRoute.withName("Calendar")
                        );
                      },
                      icon: const Icon(
                          Icons.file_copy,
                          color: Colors.white,
                          size: 75,
                          semanticLabel: 'Project Page'
                      ),
                    ),

                    //Shop Page
                    const IconButton(
                      onPressed: null,
                      icon: Icon(
                          Icons.currency_exchange,
                          color: Colors.yellow,
                          size: 75,
                          semanticLabel: 'Shop Page'
                      ),
                    ),

                    //Settings Page
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => SettingsStatsPage(title: "SettingsStats")),
                            ModalRoute.withName("Calendar")
                        );
                      },
                      icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 75,
                          semanticLabel: 'Settings Page'
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  //Method to go to settings
  Future<void> _pushSettingsStatsPage(BuildContext context) async {
    return switch (NavigationMode.current){
      NavigationMode.navigator => Navigator.of(context)
          .push<void>(SwipeablePageRoute(builder: (_) => const SettingsStatsPage(title: "Settings and Stats"))),
      NavigationMode.goRouter => GoRouter.of(context).push<void>('/settings_stats'),
      NavigationMode.goRouterBuilder => ShopPageRoute().push(context),
    };
  }
}

// widget for dynamic text field
class ItemWidget extends StatelessWidget {
  double iconSize = 100;

  ShopItem item = ShopItem("", 0, "", "default");
  String itemName = "";
  String description = "";
  //String icon = "";
  Icon icon = Icon(Icons.favorite, size: 30, color: Colors.white,);
  int coinValue = 0;

  int index = -1;

  ItemWidget(ShopItem item, int index, {super.key}){
    itemName = item.getName();
    description = item.getDescription();
    coinValue = item.getCost();
    String iconName = item.getIcon();

    switch(iconName) {
      case "shopping":
        icon = Icon(Icons.shopping_bag, size: iconSize, color: Colors.white,);
        break;
      case "drink":
        icon = Icon(Icons.coffee, size: iconSize, color: Colors.white,);
        break;
      case "food":
        icon = Icon(Icons.fastfood, size: iconSize, color: Colors.white,);
        break;
      case "social":
        icon = Icon(Icons.emoji_people, size: iconSize, color: Colors.white,);
        break;
      case "art":
        icon = Icon(Icons.brush, size: iconSize, color: Colors.white,);
        break;
      case "music":
        icon = Icon(Icons.piano, size: iconSize, color: Colors.white,);
        break;
      case "movie":
        icon = Icon(Icons.local_movies, size: iconSize, color: Colors.white,);
        break;
      case "electronics":
        icon = Icon(Icons.computer, size: iconSize, color: Colors.white,);
        break;
      case "ticket":
        icon = Icon(Icons.confirmation_num_outlined, size: iconSize, color: Colors.white,);
        break;
      case "game":
        icon = Icon(Icons.videogame_asset_rounded, size: iconSize, color: Colors.white,);
        break;
      case "book":
        icon = Icon(Icons.book, size: iconSize, color: Colors.white,);
        break;
      case "trip":
        icon = Icon(Icons.airplanemode_on, size: iconSize, color: Colors.white,);
        break;
      case "favorite":
        icon = Icon(Icons.star, size: iconSize, color: Colors.white,);
        break;
      case "heart":
        icon = Icon(Icons.favorite, size: iconSize, color: Colors.white,);
        break;
      case "other":
        icon = Icon(Icons.question_mark, size: iconSize, color: Colors.white,);
        break;
      default:
        icon = Icon(Icons.question_mark, size: iconSize, color: Colors.white,);
        break;
    }


    /*
    Shop Reward Types
    - Clothes shopping - shirt/shopping bag - shopping_bag
    - Drinks - drink/cup - coffee
    - Food - food - fastfood
    - Social outing - people - emoji_people
    - Tattoo - painting - brush
    - Music - piano - piano
    - Movies - movie camera - local_movies
    - Electronics - computer - computer
    - Amusement park - ticket - confirmation_num_outlined
    - Game icon - game controller - videogame_asset_rounded
    - Books - book - book
    - Trip - plane/boat - airplanemode_on

     */

  }

  ItemWidget.test(int num, {super.key}){
    itemName = "Test Item $num";
    description = "Test Description";
    coinValue = 100;
    icon = Icon(Icons.favorite, size: iconSize, color: Colors.red);
  }

  ItemWidget.empty({super.key}){
    itemName = "Empty";
    description = "Empty Desc";
    coinValue = 0;
    icon = Icon(Icons.question_mark, size: iconSize, color: Colors.red);
  }


  @override
  Widget build(BuildContext context){
    return Expanded(
        child:
        Container(
          color: Colors.black,
          margin: const EdgeInsets.all(1.0),
            padding: const EdgeInsets.all(0.0),
          child:
          Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              color: Colors.blue,
              //height: 200,
              //width: 100,
              child: TextButton(
                style: ButtonStyle(
                ),
                onPressed: (){
                  //Should change to item viewing page

                  // Navigator.of(context).push<void>(
                  //   MaterialPageRoute(builder: (context) => ItemViewPage(title: "Item View",)),
                  // );
                },
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      icon,
                      Text(
                        itemName,
                        style: const TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage("assets/coins.png"),
                            width: 30,
                            height: 30,
                          ),
                          Text(
                            coinValue.toString(),
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          )
                        ],
                      )
                    ]
                ),
              )
          )

        )
    );
  }
}