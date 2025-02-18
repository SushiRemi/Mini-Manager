import 'package:flutter/material.dart';
import 'package:mini_manager/projects_page.dart';
import 'package:mini_manager/settings_stats_page.dart';
import 'package:mini_manager/shop_page.dart';

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

        //Swipe left to go to settings/stats
          child: GestureDetector(
              onPanUpdate: (details) {
                //swiping in left direction
                if (details.delta.dx < 0){
                  _pushSettingsStatsPage(context);
                }
              }
          )
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
