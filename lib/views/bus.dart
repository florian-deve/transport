

import 'package:flutter/material.dart';
import 'package:transport/data/subjects.dart';
import 'package:transport/model/line_data.dart';
import 'package:transport/views/trans.dart';

class BusTrans extends StatefulWidget {
    const BusTrans({Key key,
      @required this.subject,
      @required this.onChanged,
//      @required this.chViewlines,
    })
        : super(key: key);
    final Subjects subject;
    final ValueChanged<List<LineData>> onChanged;
//    final ValueChanged<bool> chViewlines;

  @override
  _BusTransState createState() => _BusTransState();
}

class _BusTransState extends State<BusTrans> with Trans{

  var viewAllLines = true;
  var litem = [];
  var currentIndex = 0;

  void callLine(int index) {
    print('Call one line');
//    viewAllLines = !viewAllLines;
//    currentIndex = index;
//    setState(() {});
  }

  Future<void> dowloadAllLines () async {
    print('before litem.length : ${litem.length}');
    if(litem.length == 0){
      litem = await dowloadLines(widget.subject);
    }
    print('after litem.length : ${litem.length}');
  }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
          appBar: !viewAllLines ? AppBar(
              leading: MaterialButton(
                child: Icon(Icons.arrow_back),
                onPressed: () {
                  viewAllLines = !viewAllLines;
                  print('BACK3');
            setState(() {});
                },
              ),
              title: Row(children: <Widget>[
                widget.subject.icon,
                widget.subject.text,
              ],)
          ) : null,
          body: viewAllLines ?
          FutureBuilder(
              future: dowloadAllLines(),
              builder:(context, projectSnap) {
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
                      setState(() {});
                    },
                    trailing: Icon(Icons.keyboard_arrow_right),
                  );}
              );}
          )
              :
          Center(
            child: Text('Hello')
          )
        );
    }
}
