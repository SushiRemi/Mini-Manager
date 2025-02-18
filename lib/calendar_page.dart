import 'package:flutter/material.dart';
import 'package:mini_manager/projects_page.dart';
import 'package:mini_manager/shop_page.dart';
import 'package:mini_manager/main.dart';
import 'package:mini_manager/data_manager.dart';


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

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, required this.title});

  final String title;

  @override
  State<CalendarPage> createState() => _CalendarPage();
}

class _CalendarPage extends State<CalendarPage> {
  DataManager data = DataManager();

  void _save() {
    data.saveProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(

        //Swipe left to go to shop
        child: GestureDetector(
          onPanUpdate: (details) {
            //swiping in left direction
            if (details.delta.dx < 0){
              _pushProjectsPage(context);
            }
          }
        )

        /* //button to go to shop, swipe to go back.
        child: ElevatedButton(
            onPressed: () async => _pushShopPage(context),
            child: const Text("Open Shop"),
        ),
        */


        /*
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is the calendar page!',
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        */
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _save, //make sure you call it without (). wont work otherwise.
        tooltip: 'Save Projects',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  //Method to go to shop
  Future<void> _pushProjectsPage(BuildContext context) async {
    return switch (NavigationMode.current){
      NavigationMode.navigator => Navigator.of(context)
        .push<void>(SwipeablePageRoute(builder: (_) => const ProjectsPage(title: "Projects"))),
      NavigationMode.goRouter => GoRouter.of(context).push<void>('/projects'),
      NavigationMode.goRouterBuilder => ProjectsPageRoute().push(context),
    };
  }
}
