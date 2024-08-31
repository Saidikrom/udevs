class DataModel {
  final int? id;
  final String name;
  final String subname;
  final String time;
  final String hour;
  final String location;
  final String color;

  DataModel({
    this.id,
    required this.name,
    required this.subname,
    required this.time,
    required this.hour,
    required this.location,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subname': subname,
      'time': time,
      'hour': hour,
      'location': location,
      'color': color,
    };
  }

  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(
      id: map['id'],
      name: map['name'],
      subname: map['subname'],
      time: map['time'],
      hour: map['hour'],
      location: map['location'],
      color: map['color'],
    );
  }
    factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        id: json['id'],
        name: json['name'],
        subname: json['subname'],
        time: json['time'],
        hour: json['hour'],
        location: json['location'],
        color: json['color'],
      );

}

