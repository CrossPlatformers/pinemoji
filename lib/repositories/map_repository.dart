import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as lc;
import 'package:pinemoji/enums/marker-type-enum.dart';
import 'package:pinemoji/models/hospital.dart';
import 'package:pinemoji/models/request.dart';
import 'package:pinemoji/repositories/request_repository.dart';

class MapRepository {
  static final GoogleMapsPlaces places =
      GoogleMapsPlaces(apiKey: 'AIzaSyCl9rJExNnfjE4Qd3AcZ5ONJYEpfah1GTg');

  static Set<Marker> markers = {};

  static Map<String, BitmapDescriptor> bitmapDescriptorMap;

  static String collectionName = 'hospital';

  MapRepository();

  static Future<Hospital> getPlaceDetailsFromName(String query) async {
    var result = await Firestore.instance
        .collection(collectionName)
        .where("name", isEqualTo: query)
        .getDocuments();
    if (result.documents.length > 0) {
      return Hospital.fromSnapshot(result.documents.first);
    }
    PlacesAutocompleteResponse autocompleteResponse =
        await places.autocomplete(query, language: 'TR');
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
      PlacesDetailsResponse detailsByPlaceId =
          await places.getDetailsByPlaceId(prediction.placeId);
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
    bitmapDescriptorMap = {};
    MarkerType.values.forEach((markerType) {
      String path = '';
      String markerPart = markerType.toString().split('.').last;
      EmojiType.values.forEach((emojiType) async {
        await handleForEach(emojiType, path, markerPart);
//        bitmapDescriptorMap[path] =
//            BitmapDescriptor.fromBytes(await getBytesFromAsset(path));
      });
    });
    print(bitmapDescriptorMap.toString());
  }

  static Future handleForEach(
      EmojiType emojiType, String path, String markerPart) async {
    String emojiPart = (emojiType.index + 1).toString();
    path = 'assets/pins/' + markerPart + '_' + emojiPart + '.png';
    var uint8list = await getBytesFromAsset(path);
    var current = BitmapDescriptor.fromBytes(uint8list);
//    var current = await BitmapDescriptor.fromAssetImage(
//        ImageConfiguration(size: Size(8, 8),devicePixelRatio: 2), path);
    bitmapDescriptorMap.putIfAbsent(path, () => current);
    //        await print(bitmapDescriptorMap.toString());
    await print(bitmapDescriptorMap.keys);
  }

  static Future<List<Request>> getCurrentLocationMarkers({
    List<String> emojiIdList,
    String option,
    String lastSelectedId,
    int limit,
    LatLngBounds latLngBounds,
  }) async {
    clear();
    List<Request> requestList = await RequestRepository().getRequestList(
        latLngBounds: latLngBounds, emojiIdList: emojiIdList, option: option);
    Map<LatLng, List<Request>> locationMap = {};
    requestList.forEach((m) => locationMap.containsKey(m.location)
        ? locationMap[m.location].add(m)
        : locationMap[m.location] = [m]);
    locationMap.forEach((loc, mapList) {
      if (mapList.length == 2) {
        mapList.elementAt(0).location = LatLng(
            mapList.elementAt(0).location.latitude,
            mapList.elementAt(0).location.longitude - 0.000015);
        mapList.elementAt(1).location = LatLng(
            mapList.elementAt(1).location.latitude,
            mapList.elementAt(1).location.longitude + 0.000015);
      }
      if (mapList.length == 3) {
        mapList.elementAt(0).location = LatLng(
            mapList.elementAt(0).location.latitude + 0.000015,
            mapList.elementAt(0).location.longitude);
        mapList.elementAt(1).location = LatLng(
            mapList.elementAt(1).location.latitude - 0.000015,
            mapList.elementAt(1).location.longitude - 0.000015);
        mapList.elementAt(2).location = LatLng(
            mapList.elementAt(2).location.latitude - 0.000015,
            mapList.elementAt(2).location.longitude + 0.000015);
      }
      if (mapList.length == 4) {
        mapList.elementAt(0).location = LatLng(
            mapList.elementAt(0).location.latitude + 0.000015,
            mapList.elementAt(0).location.longitude - 0.000015);
        mapList.elementAt(1).location = LatLng(
            mapList.elementAt(1).location.latitude + 0.000015,
            mapList.elementAt(1).location.longitude + 0.000015);
        mapList.elementAt(2).location = LatLng(
            mapList.elementAt(2).location.latitude - 0.000015,
            mapList.elementAt(2).location.longitude - 0.000015);
        mapList.elementAt(3).location = LatLng(
            mapList.elementAt(3).location.latitude - 0.000015,
            mapList.elementAt(3).location.longitude + 0.000015);
      }
      if (mapList.length == 5) {
        mapList.elementAt(0).location = LatLng(
            mapList.elementAt(0).location.latitude + 0.00002,
            mapList.elementAt(0).location.longitude - 0.00002);
        mapList.elementAt(1).location = LatLng(
            mapList.elementAt(1).location.latitude + 0.00002,
            mapList.elementAt(1).location.longitude + 0.00002);
        mapList.elementAt(2).location = LatLng(
            mapList.elementAt(2).location.latitude - 0.00002,
            mapList.elementAt(2).location.longitude - 0.00002);
        mapList.elementAt(3).location = LatLng(
            mapList.elementAt(3).location.latitude - 0.00002,
            mapList.elementAt(3).location.longitude + 0.00002);
      }
      if (mapList.length == 6) {
        mapList.elementAt(0).location = LatLng(
            mapList.elementAt(0).location.latitude + 0.000025,
            mapList.elementAt(0).location.longitude - 0.000015);
        mapList.elementAt(1).location = LatLng(
            mapList.elementAt(1).location.latitude + 0.000025,
            mapList.elementAt(1).location.longitude + 0.000015);
        mapList.elementAt(2).location = LatLng(
            mapList.elementAt(2).location.latitude,
            mapList.elementAt(2).location.longitude - 0.000025);
        mapList.elementAt(3).location = LatLng(
            mapList.elementAt(3).location.latitude,
            mapList.elementAt(3).location.longitude + 0.000025);
        mapList.elementAt(4).location = LatLng(
            mapList.elementAt(4).location.latitude - 0.000025,
            mapList.elementAt(4).location.longitude + 0.000015);
        mapList.elementAt(5).location = LatLng(
            mapList.elementAt(5).location.latitude - 0.000025,
            mapList.elementAt(5).location.longitude + 0.000015);
      }
    });
    requestList.forEach(
      (e) {
        var elementNumb = (int.tryParse(e.emoji) - 1);
        return addMarker(e,
            emojiType: EmojiType.values.elementAt(
              elementNumb,
            ),
            markerType: getMarkerType(e.option));
      },
    );
    return requestList;
  }

  static clear() {
    markers.clear();
  }

  static addMarker(
    Request request, {
    @required MarkerType markerType,
    @required EmojiType emojiType,
  }) async {
    markers.add(
        prepareMarker(request, markerType: markerType, emojiType: emojiType));
  }

  static String getAssetName({MarkerType markerType, EmojiType emojiType}) {
    if (markerType == MarkerType.red) {
      return 'assets/pins/red_${(emojiType.index + 1)}.png';
    } else if (markerType == MarkerType.yellow) {
      return 'assets/pins/yellow_${(emojiType.index + 1)}.png';
    } else if (markerType == MarkerType.blue) {
      return 'assets/pins/blue_${(emojiType.index + 1)}.png';
    } else {
      return 'assets/pins/blue.png';
    }
  }

  static BitmapDescriptor getMarkerIcon(
      {MarkerType markerType, EmojiType emojiType}) {
    String assetName =
        getAssetName(markerType: markerType, emojiType: emojiType);
    bool containsKey = bitmapDescriptorMap.containsKey(assetName);
    if (containsKey) {
      return bitmapDescriptorMap[assetName];
    } else
      return null;
  }

  static Future<Uint8List> getBytesFromAsset(
    String path, {
    int width = 96,
  }) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  static Marker prepareMarker(Request request,
      {MarkerType markerType = MarkerType.blue, EmojiType emojiType}) {
    return Marker(
      markerId: MarkerId(
        request.id,
      ),
      position: getLatLngFromPlaceDetails(
        request.location,
      ),
      icon: getMarkerIcon(markerType: markerType, emojiType: emojiType),
    );
  }

  static LatLng getLatLngFromPlaceDetails(LatLng location) {
    return LatLng(
      location.latitude,
      location.longitude,
    );
  }

  static Marker getMarker(String id) {
    Marker marker;
    markers.forEach((element) {
      if (element.markerId.value == id) {
        marker = element;
      }
    });
    return marker;
  }

  static getMarkerType(String option) {
    if (option.toLowerCase() == 'acil destek') {
      return MarkerType.red;
    } else if (option.toLowerCase() == 'azalıyor !') {
      return MarkerType.yellow;
    } else if (option.toLowerCase() == 'yeterli') {
      return MarkerType.blue;
    } else {
      return MarkerType.blue;
    }
  }
}
