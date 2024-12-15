import 'dart:io';

import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/providers/places_provider.dart';
import 'package:favorite_places_app/widgets/image_input.dart';
import 'package:favorite_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNewPlaceScreen extends ConsumerStatefulWidget {
  const AddNewPlaceScreen({super.key});

  @override
  ConsumerState<AddNewPlaceScreen> createState() => _AddNewPlaceScreenState();
}

class _AddNewPlaceScreenState extends ConsumerState<AddNewPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedPlace;
  File? selectedImage;
  PlaceLocation? selectedPlaceLocation;

  void onSelectImage(File image) {
    setState(() {
      selectedImage = image;
    });
  }

  void onSelectCurrentLocation(PlaceLocation placeLocation) {
    setState(() {
      selectedPlaceLocation = placeLocation;
    });
  }

  void addItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    if (selectedPlaceLocation == null || selectedPlace == null) {
      return;
    }

    ref
        .read(placesProvider.notifier)
        .addNewPlace(selectedPlace!, selectedImage!, selectedPlaceLocation!);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Place"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length <= 1) {
                        return "Please enter a valid place";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      selectedPlace = value!;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ImageInput(
                    onSelectImage: onSelectImage,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LocationInput(
                    onSelectCurrentLocation: onSelectCurrentLocation,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 135,
                    child: ElevatedButton(
                      onPressed:
                          selectedImage == null || selectedPlaceLocation == null
                              ? null
                              : addItem,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 10),
                          Text("Add Place"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
