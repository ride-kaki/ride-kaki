import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class PlacesSearchDelegate extends SearchDelegate<Place?> {
  PlacesSearchDelegate({
    required String searchFieldPlaceholder,
    required this.flutterGooglePlacesSdk,
    required this.previousSearchResult,
  }) : super(
          searchFieldLabel: searchFieldPlaceholder,
          searchFieldStyle: const TextStyle(
            fontSize: 14,
          ),
        );

  static final List<PlaceField> _placeFields = [
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

  late Future<List<AutocompletePrediction>> placesPredictionList;
  late FlutterGooglePlacesSdk flutterGooglePlacesSdk;
  String previousSearchResult;
  bool firstQuery = true;

  resetSearchField(BuildContext context) async {
    // clear query field
    query = '';
    // reset results
    /*placesPredictionList = searchPlaces(context, query);*/
    placesPredictionList = searchPlaces(context, query);
    showSuggestions(context);
  }

  // making api call for search
  Future<List<AutocompletePrediction>> searchPlaces(
      BuildContext context, String query) async {
    if (firstQuery) {
      firstQuery = false;
      query = previousSearchResult;
    } else if (query.isEmpty) {
      return [];
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

  // building widget
  Widget buildResultsAndSuggestions(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if there is a query, it shouldnt pop
        bool shouldPop = query == '';
        if (!shouldPop) {
          resetSearchField(context);
        }
        return shouldPop;
      },
      child: FutureBuilder<List<AutocompletePrediction>>(
        future: placesPredictionList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
                child: Text("Failed to load results due to errors!"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                return ListTile(
                    horizontalTitleGap: 0,
                    leading: const Icon(
                      Icons.place,
                      size: 30,
                    ),
                    title: Text(
                      data.fullText,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    onTap: () async {
                      flutterGooglePlacesSdk
                          .fetchPlace(
                        data.placeId,
                        fields: _placeFields,
                      )
                          .then((value) {
                        Navigator.of(context).pop<Place?>(value.place);
                      });
                    });
              },
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text("No results found"));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(
            Icons.clear,
          ),
          onPressed: () {
            resetSearchField(context);
          },
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          if (query != '') {
            resetSearchField(context);
          } else {
            close(context, null);
          }
        },
      );

  @override
  Widget buildResults(BuildContext context) {
    placesPredictionList = searchPlaces(context, query);
    return buildResultsAndSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    placesPredictionList = searchPlaces(context, query);
    return buildResultsAndSuggestions(context);
  }
}
