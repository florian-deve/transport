import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transport/data/constants.dart';
import 'package:transport/data/subjects.dart';
import 'package:transport/model/line.dart';
import 'package:transport/model/line_data.dart';
import 'package:http/http.dart' as http;

class Trans {

  String getImg(String img) {
    if (img == null) return null;
//      print("urlApi : $urlApi | imageApi : $imageApi | img : $img");
    String url = urlApi + imageApi + img;
    return url;
  }

  Future<List<LineData>> dowloadLines(Subjects subject) async {
//    if (subject.linesData.length == 0) {
      http.Response res =
      await http.get(urlApi + linesApi + subject.name);
      print(urlApi + linesApi + subject.name);
      var objsJson = jsonDecode(res.body) as List;
      return objsJson.map((tagJson) =>
          LineData.fromJson(tagJson)).toList();
//    }
  }



}
