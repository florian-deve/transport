import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:transport/data/constants.dart';
import 'package:transport/data/subjects.dart';
import 'package:transport/model/line.dart';
import 'package:transport/model/line_data.dart';
import 'package:http/http.dart' as http;
import 'package:transport/views/trans.dart';
import 'package:transport/views/transport.dart';

class TransportRer extends StatefulWidget {
  TransportRer({Key key, @required this.subject}) :
        super(key: key);
  final Subjects subject;
  @override
  _TransportRerState createState() => _TransportRerState();
}

class _TransportRerState extends State<TransportRer> {
  int currentIndex = -1;
  var viewLines = true;
  List<LineData> litem = [];

  @override
  void initState() {
    super.initState();
    viewLines = true;
  }

  void changeViewLines() {
    viewLines = !viewLines;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<void> dowloadLines() async {
      http.Response res =
          await http.get(urlApi + linesApi + widget.subject.name);
      print("Response from dowloadLines : ${res.statusCode}");
      var objsJson = jsonDecode(res.body) as List;
      litem = objsJson.map((tagJson) => LineData.fromJson(tagJson)).toList();
    }

    String getImg(String img) {
      if (img == null) return null;
      print("urlApi : $urlApi | imageApi : $imageApi | img : $img");
      String url = urlApi + imageApi + img;
      return url;
    }

    void callLine(int index) {
      viewLines = !viewLines;
      currentIndex = index;
      setState(() {});
    }

    Future<List<String>> downloadFutureMn(
        String lineId, String stationId, String dir) async {
      http.Response res = await http.get(urlApi +
          missionsApi +
          litem[currentIndex].id +
          fromApi +
          stationId +
          wayApiA +
          dir);
      var missions = new List<String>.from(jsonDecode(res.body) as List);
      return missions;
    }

    Future<Line> callOneLine() async {
      // get lineData
      var line = new Line(litem[currentIndex]);
      http.Response res =
          await http.get(urlApi + directionApi + litem[currentIndex].id);
      var objsJson = jsonDecode(res.body) as List;
      line.directions =
          objsJson.map((tagJson) => DirectionData.fromJson(tagJson)).toList();

      // Get StationData
      http.Response sta =
          await http.get(urlApi + stationsApi + litem[currentIndex].id);
      var objsJson2 = jsonDecode(sta.body) as List;
      line.stations =
          objsJson2.map((tagJson) => StationData.fromJson(tagJson)).toList();

      var missions = await downloadFutureMn(
          litem[currentIndex].id, line.stations[0].id, "A");

      return line;
    }

    return viewLines
        ? FutureBuilder(
            future: dowloadLines(),
            builder: (context, projectSnap) {
              return ListView.builder(
                itemCount: litem.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: litem[index].image != null
                        ? Image.network(getImg(litem[index].image))
                        : widget.subject.icon,
                    title: Text(litem[index].name),
                    onTap: () {
                      callLine(index);
                    },
                    trailing: Icon(Icons.keyboard_arrow_right),
                  );
                },
              );
            },
          )
        : Container(
            padding: EdgeInsets.all(00),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AppBar(
                  title: Text(litem[currentIndex].name),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        changeViewLines();
                      },
                    )
                  ],
                ),
                Container(
                  child: null,
                ),
              ],
            ),
          );
  }
}
