import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pinemoji/repositories/map_repository.dart';
import 'package:pinemoji/widgets/search_bar.dart';

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

  String _query = 'dokuz eylül hastanesi izmir';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: SearchBar(
          onChanged: (String text) {
            _query = text;
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) async {
//                    String mapStyle = await rootBundle
//                        .loadString('assets/map_style/night.json');
//                    controller.setMapStyle(mapStyle);
                    _controller.complete(controller);
                  },
                  markers: MapRepository.markers,
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: FloatingActionButton.extended(
                    onPressed: searchAndGo,
                    label: Text('To the lake!'),
                    icon: Icon(Icons.directions_boat),
                  ),
                )
              ],
              fit: StackFit.expand,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Text('malzeme stok durumu'),
          ),
        ],
      ),
    );
  }

  Future<void> searchAndGo() async {
    PlaceDetails placeDetails =
        await MapRepository.getPlaceDetailsFromName(_query);
    LatLng latLang = MapRepository.getLatLngFromPlaceDetails(placeDetails);
    var list = MarkerType.values.toList();
    list.shuffle();
    setState(() {
      MapRepository.addMarker(placeDetails, markerType: list.first);
    });
    final GoogleMapController controller = await _controller.future;
//    LatLng(37.43296265331129, -122.08832357078792)
    controller.animateCamera(CameraUpdate.newLatLngZoom(latLang, 15));
  }
}
