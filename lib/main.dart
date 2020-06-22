import 'package:flutter/material.dart';
import 'package:transport/views/bus.dart';
import 'package:transport/views/favorites.dart';
import 'package:transport/views/metro.dart';
import 'package:transport/views/rer.dart';
import 'package:transport/views/tram.dart';
import 'package:transport/views/trans.dart';
import 'package:transport/views/transport.dart';
import 'data/subjects.dart';
import 'model/line_data.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

//  var mq = MediaQuery.of(context);
//  print(mq.size.width);		//360.0
//  print(mq.size.height);		//592.0
//  print(mq.devicePixelRatio);	//3.0

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transport schedules',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Bus schedules',),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//Init
  int _currentIndex = 0;
  var viewLines = true;
  var mediaQuery;

//Choice of tabBar
  static var bus = Bus();
  static var metro = Metro();
  static var tram = Tram();
  static var rer = Rer();
  static var favorite = Favorite();
  static List<Subjects> ls = [
    rer ,
    metro,
    bus,
    tram,
    favorite,
  ];

//Functions
  void onTabTapped(int value) {
    viewLines = true;
    setState(() {
      _currentIndex = value;
    });
  }

  onChanged(List<LineData> litem){
    ls[_currentIndex].linesData = litem;
  }

  chViewlines(bool flag){
    ls[_currentIndex].viewLines = flag;
  }
  onChangedLineSel(int index){
    ls[_currentIndex].lineSel = index;
  }

  onChangedStationSel(int index){
  }

  route() {
    switch (ls[_currentIndex].name){
        case "Rer":
          return Transport(subject:ls[_currentIndex] ,
            onChanged: onChanged,
            chViewlines: chViewlines,
            onChangedLineSel: onChangedLineSel,
              mediaQuery: mediaQuery,
            onChangedStationSel: onChangedStationSel);
        case "Metro":
          return Transport(subject:ls[_currentIndex] ,
            onChanged: onChanged,
            chViewlines: chViewlines,
              onChangedLineSel: onChangedLineSel,
              mediaQuery: mediaQuery,
              onChangedStationSel: onChangedStationSel);
        case "Bus":
          return Transport(subject:ls[_currentIndex] ,
            onChanged: onChanged,
            chViewlines: chViewlines,
              onChangedLineSel: onChangedLineSel,
              mediaQuery: mediaQuery,
              onChangedStationSel: onChangedStationSel);
        case "Tram":
          return Transport(subject:ls[_currentIndex] ,
            onChanged: onChanged,
            chViewlines: chViewlines,
              onChangedLineSel: onChangedLineSel,
              mediaQuery: mediaQuery,
              onChangedStationSel: onChangedStationSel);
        case "Favorite":
          return BusTrans(subject:ls[_currentIndex] ,
            onChanged: onChanged,
//            chViewlines: chViewlines,
            );
        }
    }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(child: route()
      ) ,
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed, // To have more than 3 tabs
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ls[0].icon,
            title: ls[0].text,
          ),
          BottomNavigationBarItem(
            icon: ls[1].icon,
            title: ls[1].text,
          ),
          BottomNavigationBarItem(
            icon: ls[2].icon,
            title: ls[2].text,
          ),
          BottomNavigationBarItem(
              icon: ls[3].icon,
              title: ls[3].text
          ),
          BottomNavigationBarItem(
              icon: ls[4].icon,
              title: ls[4].text
          )
        ],
      ),
    );
  }

}
