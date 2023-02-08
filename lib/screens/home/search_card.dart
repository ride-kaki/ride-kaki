import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_kaki/screens/home/search_button.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as google_places_sdk;
import 'package:ride_kaki/screens/promocode/promo_screen.dart';
import 'package:ride_kaki/screens/search/places_search_delegate.dart';
import 'package:ride_kaki/utils/constants.dart';

class SearchCard extends StatefulWidget {
  google_places_sdk.Place? srcSearchResult;
  google_places_sdk.Place? destSearchResult;
  void Function(google_places_sdk.Place?) updateSrcSearchResult;
  void Function(google_places_sdk.Place?) updateDestSearchResult;
  void Function(bool, LatLng?, LatLng?) mapHook;

  static String username = "Sophia";

  SearchCard({
    super.key,
    required this.srcSearchResult,
    required this.destSearchResult,
    required this.updateSrcSearchResult,
    required this.updateDestSearchResult,
    required this.mapHook,
  });

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  late final google_places_sdk.FlutterGooglePlacesSdk flutterGooglePlacesSdk;

  DraggableScrollableController scrollController =
      DraggableScrollableController();

  onPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PromoScreen(),
      ),
    );
  }

  // isUpdateDest is a boolean flag that if is true, denotes that we're updating
  // the destination, otherwise we're updating the src
  onTap(bool isUpdateDest) async {
    google_places_sdk.Place? prevSearchResult =
        isUpdateDest ? widget.destSearchResult : widget.srcSearchResult;

    google_places_sdk.Place? result =
        await showSearch<google_places_sdk.Place?>(
      context: context,
      delegate: PlacesSearchDelegate(
        searchFieldPlaceholder: "Search for your location",
        flutterGooglePlacesSdk: flutterGooglePlacesSdk,
        // TODO: change to full search object with autocomplete details
        previousSearchResult:
            prevSearchResult == null ? '' : prevSearchResult.address!,
      ),
    );

    // set state is async, so we want to animate when the states are done setting
    // so these are local vars to track states
    LatLng? _src = widget.srcSearchResult == null
        ? null
        : LatLng(widget.srcSearchResult!.latLng!.lat,
            widget.srcSearchResult!.latLng!.lng);

    LatLng? _dest = widget.destSearchResult == null
        ? null
        : LatLng(widget.destSearchResult!.latLng!.lat,
            widget.destSearchResult!.latLng!.lng);

    // update the states and local vars
    if (isUpdateDest) {
      _dest = result == null
          ? null
          : LatLng(result.latLng!.lat, result.latLng!.lng);

      widget.updateDestSearchResult(result);
    } else {
      _src = result == null
          ? null
          : LatLng(result.latLng!.lat, result.latLng!.lng);
      widget.updateSrcSearchResult(result);
    }

    widget.mapHook(
      isUpdateDest,
      _src,
      _dest,
    );
  }

  @override
  initState() {
    super.initState();
    // initialise GooglePlacesSdk
    flutterGooglePlacesSdk = google_places_sdk.FlutterGooglePlacesSdk(
      gMapsAPIKey,
      locale: gMapsPlacesLocale,
    );
    flutterGooglePlacesSdk.isInitialized().then((value) {
      debugPrint('Places Initialized: $value');
    });
    // initialise polylinePoints
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: scrollController,
      initialChildSize: 0.35,
      minChildSize: 0.20,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 0.25)),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            children: [
              const SizedBox(
                height: 10,
              ),
              FractionallySizedBox(
                widthFactor: 0.10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Colors.grey.shade300,
                  ),
                  child: const SizedBox(
                    height: 5,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // start of the card body
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, Sophia",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          flex: 7,
                          // child: FractionallySizedBox(
                          //   widthFactor: 0.90,
                          child: SearchButton(
                            onTap: () {
                              onTap(true);
                            },
                            locationText: widget.destSearchResult == null
                                ? 'Where are you heading?'
                                : widget.destSearchResult!.address!,
                          ),
                          // ),
                        ),
                        /*const SizedBox(*/
                        /*width: 20,*/
                        /*),*/
                        /*Flexible(*/
                        /*flex: 1,*/
                        /*child: IconButton(*/
                        /*splashColor: Colors.transparent,*/
                        /*highlightColor: Colors.transparent,*/
                        /*icon: const Icon(Icons.discount),*/
                        /*onPressed: onPressed,*/
                        /*),*/
                        /*)*/
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Recent Searches",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
