import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pinemoji/repositories/map_repository.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: MapRepository.markers,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: searchAndGo,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> searchAndGo() async {
    PlaceDetails placeDetails = await MapRepository.getPlaceDetailsFromName(
        'dokuz eylül hastanesi izmir');
    LatLng latLang = MapRepository.getLatLngFromPlaceDetails(placeDetails);
    setState(() {
      MapRepository.addMarker(placeDetails);
    });
    final GoogleMapController controller = await _controller.future;
//    LatLng(37.43296265331129, -122.08832357078792)
    controller.animateCamera(CameraUpdate.newLatLngZoom(latLang, 15));
  }
}
