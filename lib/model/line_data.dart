
enum NetworkId {
  metro,
  bus,
  favorite
}

enum Direction {
  A,
  R
}


class LineData {
  String id;
  String name;
  String shortName;
  String image;

  //Add for favorite managment, without json analysis
  bool favorite = false;
  String stationId = '';
  String direction = '';
  int stationSel = 0;

  LineData(this.id, this.name, this.shortName, this.image);
  factory LineData.fromJson(dynamic json) {
    return LineData(
        json['id'] as String,
        json['name'] as String,
        json['shortName'] as String,
        json['image'] as String);
  }
  @override
  String toString() {
    return 'LineData{id: $id, name: $name, shortName: $shortName, image: $image, stationSel: $stationSel}';
  }
}

class DirectionData {
  String way;
  String name;
  DirectionData(this.way, this.name);
  factory DirectionData.fromJson(dynamic json) {
    return DirectionData(
      json['way'] as String,
      json['name'] as String,
    );
  }
  @override
  String toString() {
    return 'DirectionData{way: $way, name: $name}';
  }
}

class StationData {
  String id;
  String name;
  StationData(this.id, this.name);
  factory StationData.fromJson(dynamic json) {
    return StationData(
      json['id'] as String,
      json['name'] as String,
    );
  }
  @override
  String toString() {
    return 'StationData{id: $id, name: $name}';
  }
}