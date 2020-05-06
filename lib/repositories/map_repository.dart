import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pinemoji/enums/marker-type-enum.dart';
import 'package:pinemoji/models/hospital.dart';
import 'package:pinemoji/models/request.dart';
import 'package:pinemoji/repositories/request_repository.dart';
import 'package:location/location.dart' as lc;

class MapRepository {
  static final GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: 'AIzaSyCl9rJExNnfjE4Qd3AcZ5ONJYEpfah1GTg');

  static Set<Marker> markers = {};

  static BitmapDescriptor yellow;

  static BitmapDescriptor blue;

  static BitmapDescriptor red;

  static String collectionName = 'hospital';

  MapRepository();

  static Future<Hospital> getPlaceDetailsFromName(String query) async {
    var result = await Firestore.instance.collection(collectionName).where("name", isEqualTo: query).getDocuments();
    if (result.documents.length > 0) {
      return Hospital.fromSnapshot(result.documents.first);
    }
    PlacesAutocompleteResponse autocompleteResponse = await places.autocomplete(query, language: 'TR');
    //TODO: find a good solution for not coming predictions
    Hospital h;
    if (autocompleteResponse.predictions.length == 0) {
      print('COULDNT FIND PREDICTION');
      lc.Location location = lc.Location();
      lc.PermissionStatus hasPermission = await location.hasPermission();
      h = Hospital(
        address: "",
        phoneNumber: "",
        name: query,
        mapName: "",
      );
      if (hasPermission == lc.PermissionStatus.granted) {
        lc.LocationData locationData = await location.getLocation();
        h.location = LatLng(locationData.latitude, locationData.longitude);
      } else {}
    } else {
      Prediction prediction = autocompleteResponse.predictions.first;
      PlacesDetailsResponse detailsByPlaceId = await places.getDetailsByPlaceId(prediction.placeId);
      PlaceDetails placeDetails = detailsByPlaceId.result;
      h = Hospital(
        location: LatLng(
          placeDetails.geometry.location.lat,
          placeDetails.geometry.location.lng,
        ),
        address: placeDetails.formattedAddress,
        phoneNumber: placeDetails.formattedPhoneNumber,
        name: query,
        mapName: placeDetails.name,
        id: placeDetails.placeId,
      );
    }
    Firestore.instance.collection(collectionName).document().setData(h.toMap());
    return h;
  }

  static List<Hospital> getPlaceDetails(List<String> queries) {
    List<Hospital> listOfPlaceDetails = [];
    queries.map((query) async {
      Hospital placeDetails = await getPlaceDetailsFromName(query);
      listOfPlaceDetails.add(placeDetails);
    });
    return listOfPlaceDetails;
  }

  static init() async {
    red = BitmapDescriptor.fromBytes(await getBytesFromAsset(
      getAssetName(MarkerType.red),
    ));
    yellow = BitmapDescriptor.fromBytes(await getBytesFromAsset(
      getAssetName(MarkerType.yellow),
    ));
    blue = BitmapDescriptor.fromBytes(await getBytesFromAsset(
      getAssetName(MarkerType.blue),
    ));
  }

  static Future<List<Request>> getCurrentLocationMarkers(LatLngBounds lastLatLngBounds) async {
    clear();
    List<Request> requestList = await RequestRepository().getRequestList(latLngBounds: lastLatLngBounds);
    requestList.forEach((e) => addMarker(e));
    return requestList;
  }

  static clear() {
    markers.clear();
  }

  static addMarker(
    Request request, {
    MarkerType markerType = MarkerType.blue,
  }) async {
    markers.add(prepareMarker(
      request,
      markerType: markerType,
    ));
  }

  static String getAssetName(MarkerType markerType) {
    if (markerType == MarkerType.red) {
      return 'assets/pins/red.png';
    } else if (markerType == MarkerType.yellow) {
      return 'assets/pins/yellow.png';
    } else if (markerType == MarkerType.blue) {
      return 'assets/pins/blue.png';
    } else {
      return 'assets/pins/blue.png';
    }
  }

  static BitmapDescriptor getMarkerIcon(MarkerType markerType) {
    if (markerType == MarkerType.red) {
      return red;
    } else if (markerType == MarkerType.yellow) {
      return yellow;
    } else if (markerType == MarkerType.blue) {
      return blue;
    } else {
      return red;
    }
  }

  static Future<Uint8List> getBytesFromAsset(
    String path, {
    int width = 96,
  }) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  static Marker prepareMarker(Request request, {MarkerType markerType = MarkerType.blue}) {
    return Marker(
      markerId: MarkerId(
        request.id,
      ),
      position: getLatLngFromPlaceDetails(
        request.location,
      ),
      icon: getMarkerIcon(markerType),
    );
  }

  static LatLng getLatLngFromPlaceDetails(LatLng location) {
    return LatLng(
      location.latitude,
      location.longitude,
    );
  }
}
