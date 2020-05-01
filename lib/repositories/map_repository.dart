import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class MapRepository {
  static final GoogleMapsPlaces places =
      GoogleMapsPlaces(apiKey: 'AIzaSyCl9rJExNnfjE4Qd3AcZ5ONJYEpfah1GTg');

  static Set<Marker> markers = {};

  MapRepository();

  static Future<PlaceDetails> getPlaceDetailsFromName(String query) async {
    PlacesAutocompleteResponse autocompleteResponse =
        await places.autocomplete(query, language: 'TR');
    //TODO: find a good solution for not coming predictions
    if (autocompleteResponse.predictions.length == 0) {
      print('COULDNT FIND PREDICTION');
      //sometimes predictions comes empty so that I'm calling it again
//      return getPlaceDetailsFromName(query);

    }
    Prediction prediction = autocompleteResponse.predictions.first;
    PlacesDetailsResponse detailsByPlaceId =
        await places.getDetailsByPlaceId(prediction.placeId);
    PlaceDetails placeDetails = detailsByPlaceId.result;
    return placeDetails;
  }

  static LatLng getLatLngFromPlaceDetails(PlaceDetails placeDetails) {
    return LatLng(
        placeDetails.geometry.location.lat, placeDetails.geometry.location.lng);
  }

  static List<PlaceDetails> getPlaceDetails(List<String> queries) {
    List<PlaceDetails> listOfPlaceDetails = [];
    queries.map((query) async {
      PlaceDetails placeDetails = await getPlaceDetailsFromName(query);
      listOfPlaceDetails.add(placeDetails);
    });
    return listOfPlaceDetails;
  }

  static addMarker(PlaceDetails placeDetails) {
    markers.add(
      Marker(
        markerId: MarkerId(
          placeDetails.placeId,
        ),
        position: getLatLngFromPlaceDetails(
          placeDetails,
        ),
      ),
    );
  }
}
