import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: searchAndGo,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> searchAndGo() async {
    LatLng latLang = await getLocationFromName('dokuz eylül hastanesi');
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(latLang));
  }

  Future<LatLng> getLocationFromName(String query) async {
    GoogleMapsPlaces places =
        GoogleMapsPlaces(apiKey: 'AIzaSyCl9rJExNnfjE4Qd3AcZ5ONJYEpfah1GTg');
    PlacesAutocompleteResponse autocompleteResponse =
        await places.autocomplete(query,language: 'TR');
    if (autocompleteResponse.predictions.length == 0) {
      getLocationFromName(query);
      return null;
    }
    Prediction prediction = autocompleteResponse.predictions.first;
    PlacesDetailsResponse detailsByPlaceId =
        await places.getDetailsByPlaceId(prediction.placeId);
    PlaceDetails result = detailsByPlaceId.result;
    return LatLng(result.geometry.location.lat, result.geometry.location.lng);
  }
}
