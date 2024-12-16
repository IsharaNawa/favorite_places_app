import 'dart:io';

import 'package:favorite_places_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  return await sql.openDatabase(
    path.join(dbPath, "places.db"),
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE Place(id TEXT PRIMARY KEY, name TEXT, image TEXT, lat REAL, lng REAL, address TEXT)");
    },
    version: 1,
  );
}

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  void addNewPlace(String name, File image, PlaceLocation placelocation) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final String filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    Place newPlace =
        Place(name: name, image: copiedImage, placeLocation: placelocation);

    final db = await getDatabase();

    db.insert('Place', {
      'id': newPlace.id,
      'name': newPlace.name,
      'image': newPlace.image.path,
      'lat': newPlace.placeLocation.lat,
      'lng': newPlace.placeLocation.lng,
      'address': newPlace.placeLocation.address,
    });

    state = [newPlace, ...state];
  }

  Future<void> loadDatabase() async {
    final db = await getDatabase();
    final data = await db.query("Place");

    state = data.map((row) {
      return Place(
          name: row["name"] as String,
          image: File(row["image"] as String),
          placeLocation: PlaceLocation(
              lat: row["lat"] as double,
              lng: row["lng"] as double,
              address: row["address"] as String),
          id: row["id"] as String);
    }).toList();
  }
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});
