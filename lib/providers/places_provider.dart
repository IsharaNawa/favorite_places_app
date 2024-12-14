import 'package:favorite_places_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  void addNewPlace(Place newPlace) {
    state = [...state, newPlace];
  }
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});
