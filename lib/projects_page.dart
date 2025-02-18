import 'package:flutter/material.dart';
import 'package:mini_manager/calendar_page.dart';
import 'package:mini_manager/projects_page.dart';
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

        //Swipe left to go to shop, right to go to calendar
          child: GestureDetector(
              onPanUpdate: (details) {
                //swiping in left direction
                if (details.delta.dx < 0) {
                  _pushShopPage(context);
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
