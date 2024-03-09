import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Place {
  late final String id;
  final String placeName;
  final File file;

  Place(this.placeName, this.file) : id = const Uuid().v4();
}

class AllPlaces with ChangeNotifier{
  final List<Place> places=[];
  void addPlace(Place place){
   places.add(place);
   notifyListeners();

  }

}