import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as google_places_sdk;
import 'package:ride_kaki/cubits/geolocation/geolocation_cubit.dart';
import 'package:ride_kaki/screens/home/result_card.dart';
import 'package:ride_kaki/screens/home/search_button.dart';
import 'package:ride_kaki/screens/promocode/promo_screen.dart';
import 'package:ride_kaki/screens/search/places_search_delegate.dart';
import 'package:ride_kaki/utils/constants.dart';
import 'package:ride_kaki/utils/locations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider<GeolocationCubit>(
        create: (context) => GeolocationCubit()..requestPosition(context),
        child: const HomeScreen(),
      ),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late GoogleMapController newGoogleMapController;
  late final google_places_sdk.FlutterGooglePlacesSdk flutterGooglePlacesSdk;
  google_places_sdk.Place? searchResult;

  void mapAnimateToLocation(double lat, double lng) async {
    LatLng latLngPosition = LatLng(
      lat,
      lng,
    );

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        cameraPosition,
      ),
    );
  }

  onTap() async {
    google_places_sdk.Place? result =
        await showSearch<google_places_sdk.Place?>(
      context: context,
      delegate: PlacesSearchDelegate(
        searchFieldPlaceholder: "Enter your destination",
        flutterGooglePlacesSdk: flutterGooglePlacesSdk,
        previousSearchResult:
            searchResult == null ? '' : searchResult!.address!,
      ),
    );

    // if the result isnt empty, animate to the location
    if (result != null && result.latLng != null) {
      setState(() {
        searchResult = result;
      });
      mapAnimateToLocation(result.latLng!.lat, result.latLng!.lng);
    }
  }

  @override
  initState() {
    super.initState();
    flutterGooglePlacesSdk = google_places_sdk.FlutterGooglePlacesSdk(
      placesAPIKey,
      locale: placesLocale,
    );
    flutterGooglePlacesSdk.isInitialized().then((value) {
      debugPrint('Places Initialized: $value');
    });
  }

  onPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PromoScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        toolbarHeight: 80,
        centerTitle: true,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 7,
              // child: FractionallySizedBox(
              //   widthFactor: 0.90,
              child: SearchButton(
                onTap: onTap,
                locationText: searchResult == null
                    ? 'Find the cheapest deals'
                    : searchResult!.address!,
              ),
              // ),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              flex: 1,
              child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: const Icon(Icons.discount),
                  onPressed: onPressed),
            )
          ],
        ),
      ),
      body: BlocBuilder<GeolocationCubit, GeolocationState>(
        builder: (context, state) {
          if (state is GeolocationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GeolocationLoaded) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: locationGooglePlex,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                    newGoogleMapController = controller;
                    mapAnimateToLocation(
                      state.position.latitude,
                      state.position.longitude,
                    );
                  },
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                ),
                searchResult == null ? const SizedBox.shrink() : ResultCard(),
              ],
            );
          } else {
            // show overlay to ask they to input location they with to use
            return const Center(
              child: AlertDialog(
                title: Text("You have disabled your location"),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: searchResult == null
          ? const SizedBox.shrink()
          : BottomAppBar(
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.secondary),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Book Ride in App",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
