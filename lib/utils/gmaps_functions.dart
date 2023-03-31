// making api call for search
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:ride_kaki/utils/constants.dart';
import 'package:http/http.dart' as http;

const List<PlaceField> placeFields = [
  PlaceField.Address,
  PlaceField.AddressComponents,
  PlaceField.BusinessStatus,
  PlaceField.Id,
  PlaceField.Location,
  PlaceField.Name,
  PlaceField.OpeningHours,
  PlaceField.PhoneNumber,
  PlaceField.PhotoMetadatas,
  PlaceField.PlusCode,
  PlaceField.PriceLevel,
  PlaceField.Rating,
  PlaceField.Types,
  PlaceField.UserRatingsTotal,
  PlaceField.UTCOffset,
  PlaceField.Viewport,
  PlaceField.WebsiteUri,
];
// function to search for places given a query
Future<List<AutocompletePrediction>> searchPlaces(
  BuildContext context,
  String query,
  FlutterGooglePlacesSdk flutterGooglePlacesSdk,
) async {
  if (query.length < 3 || query.isEmpty) {
    return Future.value([]);
  }

  final results = await flutterGooglePlacesSdk.findAutocompletePredictions(
    query,
    countries: ['sg'],
    newSessionToken: false,
    /*origin: LatLng(lat: 43.12, lng: 95.20),*/
    /*locationBias: _locationBiasEnabled ? _locationBias : null,*/
    /*locationRestriction: LatLngBounds()*/
  );
  return results.predictions;
  // actual search method
}

Future<String?> searchPlacesWithLatLng(double lat, double long) async {
  String apiKey = gMapsAPIKey;
  String uri =
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apiKey";

  try {
    http.Response res = await http.get(Uri.parse(uri));
    print(jsonDecode(res.body).toString());
    if (res.statusCode == 200) {
      dynamic decodedRes = jsonDecode(res.body);
      dynamic results = decodedRes['results'];
      if (results.length > 0) {
        // get results
        return results[0]['formatted_address'];
      } else {
        throw Exception(results['error_message']);
      }
    }
  } catch (e) {
    print(e);
  }
}
