//connecting to other pages
import 'package:flutter/material.dart';
import 'package:mini_manager/calendar_page.dart';
import 'package:mini_manager/project.dart';
import 'package:mini_manager/shopitem.dart';
import 'data_manager.dart';
import 'package:mini_manager/data_manager.dart';

//imports for saving/loading files
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';


//used for swiping between pages
import 'package:go_router/go_router.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'go_router.dart';





void main() {
  //Main method. starts the app globally, don't need for every page.
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
        // home: const CalendarPage(title: 'Calendar')
        home: const SplashPage(title: 'Splash')
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
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CalendarPage(title: "Calendar"))
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return const Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Image(
          image: AssetImage("assets/minimanalogopurple.png"),
          width: 200,
          height: 200,
        )
      ),
    );
  }
}
