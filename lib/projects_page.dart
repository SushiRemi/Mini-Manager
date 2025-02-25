import 'package:flutter/material.dart';
import 'package:mini_manager/calendar_page.dart';
import 'package:mini_manager/projects_page.dart';
import 'package:mini_manager/shop_page.dart';
import 'package:mini_manager/settings_stats_page.dart';

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

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key, required this.title});

  final String title;

  @override
  State<ProjectsPage> createState() => _ProjectsPage();
}

class _ProjectsPage extends State<ProjectsPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(

        // //Swipe left to go to shop, right to go to calendar
        //   child: GestureDetector(
        //       onPanUpdate: (details) {
        //         //swiping in left direction
        //         if (details.delta.dx < 0) {
        //           _pushShopPage(context);
        //         }
        //       }
        //   )

        child: Column(
          children: [
            //Project List
            Expanded(
              flex: 7,
                child: ListView(
                  children: [
                    Container(
                      height: 100,
                      color: Colors.purple
                    ),
                    Container(
                      height: 100,
                      color: Colors.red
                    ),
                    Container(
                        height: 100,
                        color: Colors.purple
                    ),
                    Container(
                        height: 100,
                        color: Colors.red
                    ),
                    Container(
                        height: 100,
                        color: Colors.purple
                    ),
                    Container(
                        height: 100,
                        color: Colors.red
                    ),
                    Container(
                        height: 100,
                        color: Colors.purple
                    ),
                    Container(
                        height: 100,
                        color: Colors.red
                    ),
                    Container(
                        height: 100,
                        color: Colors.purple
                    ),
                    Container(
                        height: 100,
                        color: Colors.red
                    ),

                  ],
                )
            ),

            //Bottom Nav Bar
            Expanded(
              flex: 1,
              child: BottomAppBar(
                color: Colors.green,
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
                          color: Colors.yellow,
                          size: 75,
                          semanticLabel: 'Calendar Page'
                      ),
                    ),

                    //Project Page
                    const IconButton(
                      onPressed: null,
                      icon: Icon(
                          Icons.file_copy,
                          color: Colors.yellow,
                          size: 75,
                          semanticLabel: 'Project Page'
                      ),
                    ),

                    //Shop Page
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => ShopPage(title: "Shop")),
                            ModalRoute.withName("Calendar")
                        );
                      },
                      icon: const Icon(
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
                          color: Colors.yellow,
                          size: 75,
                          semanticLabel: 'Settings Page'
                      ),
                    ),
                  ],
                ),
              ),
            )

          ],
        ),

      ),

    );
  }

  //Method to go to shop
  Future<void> _pushShopPage(BuildContext context) async {
    return switch (NavigationMode.current){
      NavigationMode.navigator => Navigator.of(context)
          .push<void>(SwipeablePageRoute(builder: (_) => const ShopPage(title: "Shop"))),
      NavigationMode.goRouter => GoRouter.of(context).push<void>('/shop'),
      NavigationMode.goRouterBuilder => ShopPageRoute().push(context),
    };
  }

  //Method to go to calendar
  Future<void> _pushCalendarPage(BuildContext context) async {
    return switch (NavigationMode.current){
      NavigationMode.navigator => Navigator.of(context)
          .push<void>(SwipeablePageRoute(builder: (_) => const CalendarPage(title: "Calendar"))),
      NavigationMode.goRouter => GoRouter.of(context).push<void>('/calendar'),
      NavigationMode.goRouterBuilder => CalendarPageRoute().push(context),
    };
  }
}
