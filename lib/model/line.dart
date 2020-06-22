import 'dart:ui';
import 'line_data.dart';

class Line {
  LineData lineData;
  Image imageData;
  int index = 0;
  List<StationData> stations;
  List<DirectionData> directions; // []
  bool favorite;

  Line(lineData){
    this.lineData = lineData;
    directions = [];
  }

  @override
  String toString() {
    return 'Line{lineData: $lineData, favorite: $favorite, index: $index}';
  } // Constructor

}