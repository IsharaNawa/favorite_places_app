import 'dart:convert';

import 'package:favorite_places_app/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  LocationInput({super.key, required this.onSelectCurrentLocation});

  void Function(PlaceLocation placeLocation) onSelectCurrentLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool isGettingCurrentLocation = false;
  PlaceLocation? selectedCurrentLocation;

  String get locationImage {
    if (selectedCurrentLocation == null) {
      return "";
    }

    double lat = selectedCurrentLocation!.lat;
    double lng = selectedCurrentLocation!.lng;

    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyCi1VavBVcDBYQ0JOKU5Kes9RHBBNMbqJg";
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettingCurrentLocation = true;
    });

    locationData = await location.getLocation();

    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    if (latitude == null || longitude == null) {
      return;
    }

    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyCi1VavBVcDBYQ0JOKU5Kes9RHBBNMbqJg");
    final response = await http.get(url);
    final address =
        json.decode(response.body)["results"][0]["formatted_address"];

    setState(() {
      selectedCurrentLocation = PlaceLocation(
        lat: latitude,
        lng: longitude,
        address: address,
      );
      widget.onSelectCurrentLocation(selectedCurrentLocation!);
      isGettingCurrentLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      "No location selected",
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    if (isGettingCurrentLocation) {
      content = const CircularProgressIndicator();
    }

    if (selectedCurrentLocation != null) {
      content = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                5,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: content,
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getCurrentLocation,
              icon: const Icon(Icons.location_pin),
              label: const Text("Get Current Location"),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text("Select on Map"),
            ),
          ],
        ),
      ],
    );
  }
}
