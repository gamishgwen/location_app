import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:location_app/local_source.dart';
import 'package:uuid/uuid.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final String address;

  LocationData(
      {required this.latitude, required this.longitude, required this.address});

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

class AllPlaces with ChangeNotifier {
  List<Place> places = [];

  Future<void> loadPlaces() async {
    final PlaceLocalSource localSource = PlaceLocalSource();
    places = await localSource.loadPlace();
    notifyListeners();
  }

  Future<void> insertPlace(Place placeNew) async {
    final PlaceLocalSource localSource = PlaceLocalSource();
    await localSource.insertPlace(placeNew);
    loadPlaces();
  }
}
