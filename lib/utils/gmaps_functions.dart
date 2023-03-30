// making api call for search
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

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

// TODO: create a function to find a place by latlng
