import 'package:favorite_places_app/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.placeLocation = const PlaceLocation(
        lat: 37.422, lng: -122.084, address: "Google Office Building"),
    this.isSelecting = true,
  });

  final PlaceLocation placeLocation;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? userPickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting ? "Pick your location" : "Your location",
        ),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                if (userPickedLocation == null) {
                  return;
                }
                Navigator.of(context).pop(userPickedLocation);
              },
            )
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (userLocation) {
                setState(() {
                  userPickedLocation = userLocation;
                });
              },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.placeLocation.lat,
            widget.placeLocation.lng,
          ),
          zoom: 16,
        ),
        markers: {
          widget.isSelecting && userPickedLocation != null
              ? Marker(
                  markerId: const MarkerId("m1"),
                  position: userPickedLocation!,
                )
              : Marker(
                  markerId: const MarkerId("m1"),
                  position: LatLng(
                    widget.placeLocation.lat,
                    widget.placeLocation.lng,
                  ),
                )
        },
      ),
    );
  }
}
