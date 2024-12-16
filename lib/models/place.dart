import 'dart:io';

import 'package:uuid/uuid.dart';

const idGenerator = Uuid();

class PlaceLocation {
  const PlaceLocation(
      {required this.lat, required this.lng, required this.address});

  final double lat;
  final double lng;
  final String address;
}

class Place {
  Place(
      {required this.name,
      required this.image,
      required this.placeLocation,
      id})
      : id = id ?? idGenerator.v4();

  final String id;
  final String name;
  final File image;
  final PlaceLocation placeLocation;
}
