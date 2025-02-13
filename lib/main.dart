import 'package:flutter/material.dart';
import 'package:mini_manager/calendar_page.dart';
import 'package:mini_manager/project.dart';
import 'package:mini_manager/shopitem.dart';


//used for swiping between pages
import 'package:go_router/go_router.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'go_router.dart';

//connecting to other pages
import 'calendar_page.dart';
import 'shop_page.dart';
import 'projects_page.dart';
import 'settings_stats_page.dart';

//Lists of projects, items, and other stats tracked throughout program life
var projectList = <Project>[];
var shopList = <ShopItem>[];
var stats = <int>[]; //includes coin amount

//saves the current project, item, and stats to the save file.
void saveAll(){
  saveProjects();
  saveShop();
  saveStats();
}

//loads a project list, item list, and stats from a save file
void loadAll(){
  loadProjects();
  loadShop();
  loadStats();
}

//saves the current projectList to a file
void saveProjects(){

}

//loads a projectList from a file
void loadProjects(){

}

//saves the current shopList to a file
void saveShop(){

}

//loads a shopList from a file
void loadShop(){

}

//saves the current stats to a file
void saveStats(){

}

//loads stats from a file
void loadStats(){

}

void main() { //Main method. starts the app globally, don't need for every page.
  runApp(const MyApp());
}

enum NavigationMode{
  navigator,
  goRouter,
  goRouterBuilder;

  static const current = NavigationMode.navigator; //change this to switch between navigation modes
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const title = ('MiniMana');
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    );

    //Navigation goRouter code for page swiping
    return switch (NavigationMode.current){
      NavigationMode.navigator => MaterialApp(
        title: title,
        theme: theme,
        home: const CalendarPage(title: 'Calendar')
      ),
      NavigationMode.goRouter => MaterialApp.router(
        title: title,
        theme: theme,
        routerConfig: goRouter,
      ),
      NavigationMode.goRouterBuilder => MaterialApp.router(
        title: title,
        theme: theme,
        routerConfig: goRouterBuilder,
      )
    };
  }


}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
