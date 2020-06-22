import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transport/data/constants.dart';
import 'package:transport/data/subjects.dart';
import 'package:transport/model/line.dart';
import 'package:transport/model/line_data.dart';
import 'package:http/http.dart' as http;

class Transport extends StatefulWidget {
  Transport(
      {Key key,
      @required this.subject,
      @required this.onChanged,
      @required this.chViewlines,
      @required this.onChangedLineSel,
      @required this.mediaQuery,
      @required this.onChangedStationSel})
      : super(key: key);
  final Subjects subject;
  final ValueChanged<List<LineData>> onChanged;
  final ValueChanged<bool> chViewlines;
  final ValueChanged<int> onChangedLineSel;
  final double mediaQuery;
  final ValueChanged<int> onChangedStationSel;

  @override
  _TransportState createState() => _TransportState();
}

class _TransportState extends State<Transport> {
  List<Widget> hourList;
  var litemEmpty = true;
  var hourOneText = '';
  Line line;
  var direction = "A";
  var itemsHours = [];
  var stationSelectioned = 0;
  FixedExtentScrollController controller = FixedExtentScrollController();

  void onChanged(litem) {
    widget.onChanged(litem);
  }

  chViewlines(bool flag) {
    widget.chViewlines(flag);
  }

  @override
  void initState() {
    super.initState();
    widget.subject.viewLines = true;
    widget.subject.linesData.length == 0
        ? litemEmpty = true
        : litemEmpty = false;
  }

  @override
  void didUpdateWidget(Transport oldWidget) {
    itemsHours = [];
    if (!widget.subject.viewLines) {
      if (!widget.subject.viewLines) {
        controller.jumpToItem(
            widget.subject.linesData[widget.subject.lineSel].stationSel);
        stationInit();
      }
    }
  }

  void changeViewLines() {
    widget.subject.viewLines = !widget.subject.viewLines;
    chViewlines(widget.subject.viewLines);
    setState(() {});
  }

  void viewLines2true() {
    !widget.subject.viewLines ? changeViewLines() : null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.subject.viewLines
        ? FutureBuilder(
            future: dowloadLines(),
            builder: (context, projectSnap) {
              return ListView.builder(
                itemCount: widget.subject.linesData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: widget.subject.linesData[index].image != null
                        ? Image.network(
                            getImg(widget.subject.linesData[index].image))
                        : widget.subject.icon,
                    title: Text(widget.subject.linesData[index].name),
                    onTap: () {
                      callLine(index);
                    },
                    trailing: Icon(Icons.keyboard_arrow_right),
                  );
                },
              );
            },
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FutureBuilder<Line>(
                future: callOneLine(),
                builder: (BuildContext context, AsyncSnapshot<Line> line) {
                  List<Widget> children = [];
                  if (line.hasData) {
                    children = <Widget>[
                      AppBar(
                          leading: MaterialButton(
                            child: Icon(Icons.arrow_back),
                            onPressed: () {
                              viewLines2true();
                              setState(() {});
                            },
                          ),
                          title: Container(
                            child: Center(
                              child: Row(children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 30, 00),
                                  child: widget.subject.icon,
                                ),
                                Text(line.data.lineData.shortName),
                              ]),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: Column(
                          //TODO: Space between elements
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              direction == "A"
                                  ? '${line.data.directions[1].name}'
                                  : '${line.data.directions[0].name}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            MaterialButton(
                                child: Icon(Icons.cached),
                                onPressed: chgDirection),
                            Text(
                              direction == "R"
                                  ? '${line.data.directions[1].name}'
                                  : '${line.data.directions[0].name}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                              height: 200.0,
                              child: CupertinoPicker.builder(
                                  diameterRatio: 1.2,
                                  itemExtent: 40.0,
                                  //Picker station change
                                  onSelectedItemChanged: stationChange,
                                  scrollController: controller,
                                  itemBuilder: (context2, index) {
                                    return Center(
                                      child: Text(
                                        line.data.stations[index].name,
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                  childCount: line.data.stations.length),
                            ),
                            SizedBox(
                              width: 240,
                              height: 70,
                              child: ListView.builder(
                                  itemCount: itemsHours.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return Center(
                                        child: new Text(itemsHours[index]));
                                  }),
                            ),
                          ],
                        ),
                      )
                    ];
                  } else if (line.hasError) {
                    var wid = AppBar(
                        leading: MaterialButton(
                          child: Icon(Icons.arrow_back),
                          onPressed: () {
                            viewLines2true();
                            setState(() {});
                          },
                        ),
                        title: Container(
                          child: Center(
                            child: Row(children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 30, 00),
                                child: widget.subject.icon,
                              ),
                            ]),
                          ),
                        ));
                    children.add(wid);
                    children = lineError(children, line);
                  } else {
                    children = waitingLine(children);
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
                    ),
                  );
                },
              ),
            ],
          );
  }

  Future<void> dowloadLines() async {
    if (widget.subject.linesData.length == 0) {
      http.Response res =
          await http.get(urlApi + linesApi + widget.subject.name);
      var objsJson = jsonDecode(res.body) as List;
      widget.subject.linesData =
          objsJson.map((tagJson) => LineData.fromJson(tagJson)).toList();
      onChanged(widget.subject.linesData);
    }
  }

  String getImg(String img) {
    if (img == null) return null;
    String url = urlApi + imageApi + img;
    return url;
  }

  void callLine(int index) {
    changeViewLines();
    widget.subject.lineSel = index;
    setState(() {});
  }

  Future<List<String>> downloadFutureMn(
    String lineId,
    String stationId,
  ) async {
    http.Response res = await http.get(urlApi +
        missionsApi +
        widget.subject.linesData[widget.subject.lineSel].id +
        fromApi +
        stationId +
        wayApiA +
        direction);
    if (res.body == "") {
      return [];
    }
    var missions = new List<String>.from(jsonDecode(res.body) as List);
    return missions;
  }

  Future<Line> callOneLine() async {
    // get lineData
    line = new Line(widget.subject.linesData[widget.subject.lineSel]);
    http.Response res = await http.get(urlApi +
        directionApi +
        widget.subject.linesData[widget.subject.lineSel].id);
    var objsJson = jsonDecode(res.body) as List;
    line.directions =
        objsJson.map((tagJson) => DirectionData.fromJson(tagJson)).toList();
    // Get StationData
    http.Response sta = await http.get(urlApi +
        stationsApi +
        widget.subject.linesData[widget.subject.lineSel].id);
    var objsJson2 = jsonDecode(sta.body) as List;
    line.stations =
        objsJson2.map((tagJson) => StationData.fromJson(tagJson)).toList();
    line.index = widget.subject.linesData[widget.subject.lineSel].stationSel;
    getHours();
    return line;
  }

  Future<void> getHours() async {
    if (line.stations == null || line.stations.length == 0) return;
    var lineNb = widget.subject.lineSel;
    var stationSel = widget.subject.linesData[lineNb].stationSel;
    var stationId = line.stations[stationSel].id;
    var hours = await downloadFutureMn(line.lineData.id, stationId);
    itemsHours = hours;
//    hourList = hours.map((h) => new Text(h)).toList();
    print('getHours hours : $hours');
  }

  void stationChange(index) {
    print('StationChange');
    widget.subject.linesData[widget.subject.lineSel].stationSel = index;
    widget.onChangedStationSel(index);
    line.index = index;
    getHours();
    setState(() {});
  }

  Future<void> stationInit() async {
    if (line.stations == null || line.stations.length == 0) return;
    var lineNb = widget.subject.lineSel;
    var stationSel = widget.subject.linesData[lineNb].stationSel;
    var stationId = line.stations[stationSel].id;
    downloadFutureMn(line.lineData.id, stationId).then((value) => {
      setState(() {
        itemsHours = value;
      }),
    });
  }

  void chgDirection() {
    direction = direction == "A" ? "R" : "A";
    setState(() {
      getHours();
    });
  }

  List<Widget> waitingLine(List<Widget> children) {
    children = <Widget>[
      SizedBox(
        child: CircularProgressIndicator(),
        width: 60,
        height: 60,
      ),
      const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Awaiting result...'),
      )
    ];
    return children;
  }

  List<Widget> lineError(List<Widget> children, AsyncSnapshot<Line> line) {
    children = <Widget>[
      Icon(
        Icons.error_outline,
        color: Colors.yellow,
        size: 60,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text('Error: ${line.error}'),
      )
    ];
    return children;
  }

  List<Widget> detailsLine(
      AsyncSnapshot<List<String>> snapshot, List<Widget> children) {
    if (snapshot.hasData) {
      List<Text> myWidgets = snapshot.data.map((item) {
        return new Text(item);
      }).toList();
      children = <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          children: myWidgets,
        )
      ];
    } else if (snapshot.hasError) {
      children = <Widget>[
        Icon(
          Icons.error,
          color: Colors.blue,
          size: 10,
        )
      ];
    } else {
      children = <Widget>[
        SizedBox(
          child: CircularProgressIndicator(),
          width: 30,
          height: 30,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text('Awaiting result...'),
        )
      ];
    }
    return children;
  }
}
