import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:ride_kaki/utils/gmaps_functions.dart';

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
        ) {}

  late Future<List<AutocompletePrediction>> placesPredictionList;
  late FlutterGooglePlacesSdk flutterGooglePlacesSdk;
  String previousSearchResult;
  bool firstQuery = true;

  Future<List<AutocompletePrediction>> _searchPlaces(
    BuildContext context,
    String query,
  ) async {
    // actual search
    return searchPlaces(
      context,
      query,
      flutterGooglePlacesSdk,
    );
  }

  resetSearchField(BuildContext context) async {
    // clear query field
    query = '';
    // reset results
    /*placesPredictionList = searchPlaces(context, query);*/
    placesPredictionList = _searchPlaces(context, query);
    showSuggestions(context);
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
          if (firstQuery) {
            firstQuery = false;
            query = previousSearchResult;
            buildSuggestions(context);
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text("Failed to load results due to errors!"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];

                // searchPlaces
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
                      try {
                        flutterGooglePlacesSdk
                            .fetchPlace(
                          data.placeId,
                          fields: placeFields,
                        )
                            .then((value) {
                          Navigator.of(context).pop<Place?>(value.place);
                        });
                      } catch (e) {
                        Navigator.of(context).pop<Place?>(null);
                      }
                    });
              },
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            // on initial load
            return const Center(child: Text(""));
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
            // close search and return null
            close(context, null);
          }
        },
      );

  @override
  Widget buildResults(BuildContext context) {
    placesPredictionList = _searchPlaces(context, query);
    return buildResultsAndSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    placesPredictionList = _searchPlaces(context, query);
    return buildResultsAndSuggestions(context);
  }
}
