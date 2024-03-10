import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class LocationData{
  final double latitude;
  final double longitude;
  final String address;

  LocationData({required this.latitude,required this.longitude, required this.address});

  @override
  String toString() {
    return 'LocationData{latitude: $latitude, longitude: $longitude, address: $address}';
  }
}

class Place {
  late final String id;
  final String placeName;
  final File file;
  final LocationData location;

  Place(this.placeName, this.file, this.location) : id = const Uuid().v4();

  @override
  String toString() {
    return 'Place{id: $id, placeName: $placeName, file: $file, location: $location}';
  }
}

class AllPlaces with ChangeNotifier{
  final List<Place> places=[];
  void addPlace(Place place){
   places.add(place);
   notifyListeners();

  }

}