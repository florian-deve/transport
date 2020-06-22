import 'package:flutter/material.dart';
import 'package:transport/model/line.dart';
import 'package:transport/model/line_data.dart';
import 'package:transport/views/bus.dart';
import 'package:transport/views/trans.dart';
import 'package:transport/views/transport.dart';



abstract class Subjects {
  String name = "Unknown";
  Text text = new Text('Unknown');
  Icon icon = new Icon(Icons.error);
  bool isFavorite = false;
  bool viewLines = true;
  List<LineData> linesData = [];
  int lineSel = 0;
}


class Bus extends Subjects {
  String name =  "Bus";
  Text text = new Text('Bus');
  Icon icon = new Icon(Icons.directions_bus);
  bool isFavorite = false;
}


class Metro extends Subjects {
  String name =  "Metro";
  Text text = new Text('Metro');
  Icon icon = new Icon(Icons.directions_railway);
  bool isFavorite = false;
}


class Tram extends Subjects {
  String name =  "Tram";
  Text text = new Text('tram');
  Icon icon = new Icon(Icons.tram);
  bool isFavorite = false;
  List<LineData> linesData = [];
}


class Rer extends Subjects {
  String name =  "Rer";
  Text text = new Text('Rer');
  Icon icon = new Icon(Icons.train);
  bool isFavorite = false;
}


class Favorite extends Subjects {
  String name =  "Favorite";
  Text text = new Text('Favorite');
  Icon icon = new Icon(Icons.favorite);
  bool isFavorite = true;
}
