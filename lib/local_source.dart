import 'dart:io';

import 'package:location_app/places.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:sqflite/sqflite.dart' as sql;

class PlaceLocalSource {
  final String _tableName = 'user_place';

  Future<sql.Database> initiatePlaceDB() async {
    final String dbPath = await sql.getDatabasesPath();
    final sql.Database db = await sql
        .openDatabase(path.join(dbPath, 'place.db'), onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $_tableName(id Text PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    }, version: 1);
    return db;
  }

  Future<void> insertPlace(Place place) async {
    final File copiedImage = await copyFileToLocalAppDir(place.file);
    final sql.Database db = await initiatePlaceDB();
    db.insert(_tableName, {
      'id': place.id,
      'title': place.placeName,
      'image': copiedImage.path,
      'lat': place.location.latitude,
      'lng': place.location.longitude,
      'address': place.location.address
    });
  }

  Future<List<Place>> loadPlace() async {
    final sql.Database db = await initiatePlaceDB();
    final List<Map<String, dynamic>> rawPlace = await db.query(_tableName);
    final List<Place> places = rawPlace
        .map((e) => Place(
            e['title'],
            File(e['image']),
            LocationData(
                latitude: e['lat'],
                longitude: e['lng'],
                address: e['address'])))
        .toList();
    return places;
  }

  Future<File> copyFileToLocalAppDir(File file) async {
    final Directory appDir = await syspath.getApplicationDocumentsDirectory();
    final String fileName = path.basename(file.path);
    final File copiedFile = await file.copy(path.join(appDir.path, fileName));
    return copiedFile;
  }
}
