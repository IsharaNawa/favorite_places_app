import 'package:favorite_places_app/providers/places_provider.dart';
import 'package:favorite_places_app/screens/add_new_place_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  void addItem() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddNewPlaceScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final placesList = ref.watch(placesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Places",
        ),
        actions: [
          IconButton(
            onPressed: addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: ListView(
        children: [
          ...placesList.map(
            (place) => ListTile(
              key: ValueKey(place.id),
              title: Text(place.name),
            ),
          )
        ],
      ),
    );
  }
}
