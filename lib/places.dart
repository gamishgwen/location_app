import 'package:flutter/cupertino.dart';

class Place {
  final String placeName;

  Place(this.placeName);

  factory Place.fromJson(Map<String, dynamic> mapEntry){
    return Place(mapEntry['name']!);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': placeName,

    };
  }

}