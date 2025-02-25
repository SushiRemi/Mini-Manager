import 'package:flutter/material.dart';
import 'package:mini_manager/projects_page.dart';
import 'package:mini_manager/settings_stats_page.dart';
import 'package:mini_manager/shop_page.dart';
import 'package:mini_manager/calendar_page.dart';

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
        leading: null,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Coin Shop"),
      ),
      body: Center(
        child: Column(
          children: [
            //Project List
            Expanded(
                flex: 7,
                child: ListView(
                  children: [
                    Container(
                        height: 210,
                        child: Row(
                          children: [
                            Expanded(child: Container(color: Colors.blue)),
                            Expanded(child: Container(color: Colors.orange)),
                          ],
                        )
                    ),
                    Container(
                        height: 210,
                        child: Row(
                          children: [
                            Expanded(child: Container(color: Colors.orange)),
                            Expanded(child: Container(color: Colors.blue)),
                          ],
                        )
                    ),
                    Container(
                        height: 210,
                        child: Row(
                          children: [
                            Expanded(child: Container(color: Colors.blue)),
                            Expanded(child: Container(color: Colors.orange)),
                          ],
                        )
                    ),
                    Container(
                        height: 210,
                        child: Row(
                          children: [
                            Expanded(child: Container(color: Colors.orange)),
                            Expanded(child: Container(color: Colors.blue)),
                          ],
                        )
                    ),
                    Container(
                        height: 210,
                        child: Row(
                          children: [
                            Expanded(child: Container(color: Colors.blue)),
                            Expanded(child: Container(color: Colors.orange)),
                          ],
                        )
                    ),
                    Container(
                        height: 210,
                        child: Row(
                          children: [
                            Expanded(child: Container(color: Colors.orange)),
                            Expanded(child: Container(color: Colors.blue)),
                          ],
                        )
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
