/*

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:transport/data/constants.dart';
import 'package:transport/data/subjects.dart';
import 'package:transport/model/line.dart';
import 'package:transport/model/line_data.dart';
import 'package:http/http.dart' as http;
import 'package:transport/views/trans.dart';
import 'package:transport/views/transport.dart';


class TransportTram extends StatefulWidget {
  TransportTram({Key key, @required this.subject}) :
        super(key: key);
  final Subjects subject;
  @override
  _TransportTramState createState() => _TransportTramState();
}

class _TransportTramState extends State<TransportTram> with Trans {
  int currentIndex = -1;
  var viewLines = true;
  var station = '';
  List<LineData> litem = [];

  @override
  Future<void> initState() {
    super.initState();
    viewLines = true;
  }

  void callLine(int index) {
    viewLines = !viewLines;
    currentIndex = index;
    setState(() {});
  }

  void changeViewLines() {
    viewLines = !viewLines;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return viewLines
        ? FutureBuilder(
      future: dowloadLines(widget.subject.name),
      builder: (context, projectSnap) {
        return ListView.builder(
          itemCount: projectSnap.data != null ? projectSnap.data.length : 0,
          itemBuilder: (context, index) {
            return ListTile(
              leading: projectSnap.data[index].image != null
                  ? Image.network(getImg(projectSnap.data[index].image))
                  : widget.subject.icon,
              title: Text(projectSnap.data[index].name),
              onTap: () {
                callLine(index);
              },
              trailing: Icon(Icons.keyboard_arrow_right),
            );
          },
        );
      },
    ) : Container(
      padding: EdgeInsets.all(00),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AppBar(
            title: Text('litem[currentIndex].name'),
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
}*/
