import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_kaki/cubits/geolocation/geolocation_cubit.dart';
import 'package:ride_kaki/screens/home/result_card.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as google_places_sdk;
import 'package:ride_kaki/screens/home/search_button.dart';
import 'package:ride_kaki/screens/home/search_card.dart';
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

  google_places_sdk.Place? srcSearchResult;
  google_places_sdk.Place? destSearchResult;
  late GoogleMapController newGoogleMapController;
  late final google_places_sdk.FlutterGooglePlacesSdk flutterGooglePlacesSdk;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  late PolylinePoints polylinePoints;

  void mapHook(
    bool isUpdateDest,
    LatLng? _src,
    LatLng? _dest,
  ) {
    // draw pins
    drawPin(
      isUpdateDest ? _dest : _src,
      isUpdateDest ? 'destinationPin' : 'sourcePin',
    );

    // draw polylines
    drawPolylines(
      _src,
      _dest,
    );

    // check if the result selected was null
    // if both locations are filled in
    if (_dest != null && _src != null) {
      // animate to boundary locations
      mapAnimateToBounds(_src, _dest);
    }
    // if the result isn't empty and there is 1 location filled, animate to 1 location
    else if (_dest == null && _src == null) {
      //TODO: add animation to geolocation latlng
      /*LatLng _latLng =*/
      /*LatLng(state.position.latitude, state.position.longitude);*/
      /*mapAnimateToTarget(_latLng);*/
    } else if (_dest == null || _src == null) {
      // animate to single location
      mapAnimateToTarget(_src ?? _dest!);
    }
  }

  void mapAnimateToTarget(LatLng targetLatLng) async {
    CameraPosition cameraPosition =
        CameraPosition(target: targetLatLng, zoom: 14);

    newGoogleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        cameraPosition,
      ),
    );
  }

  void mapAnimateToBounds(LatLng firstLocation, LatLng secondLocation) {
    final LatLng southwest = LatLng(
      min(firstLocation.latitude, secondLocation.latitude),
      min(firstLocation.longitude, secondLocation.longitude),
    );

    final LatLng northeast = LatLng(
      max(firstLocation.latitude, secondLocation.latitude),
      max(firstLocation.longitude, secondLocation.longitude),
    );
    LatLngBounds bounds = LatLngBounds(
      southwest: southwest,
      northeast: northeast,
    );

    newGoogleMapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        20.0,
      ),
    );
  }

  void drawPolylines(LatLng? src, LatLng? dest) async {
    List<LatLng> polylinesLatLng = [];
    // if either src or destination is empty, there shouldn't be any polylines
    if (src == null || dest == null) {
      setState(() {
        polylines = {};
      });
    }
    // otherwise there should be a polyline, but we should clear the existing ones first
    else {
      PolylineResult polylineResult =
          await polylinePoints.getRouteBetweenCoordinates(
        gMapsAPIKey,
        PointLatLng(
          src.latitude,
          src.longitude,
        ),
        PointLatLng(
          dest.latitude,
          dest.longitude,
        ),
      );

      // replace all polylines with the current one
      if (polylineResult.status == "OK") {
        Set<Polyline> _polylines = {};

        polylineResult.points.forEach((PointLatLng point) {
          polylinesLatLng.add(LatLng(point.latitude, point.longitude));
        });

        _polylines.add(Polyline(
          width: 5,
          polylineId: const PolylineId("polyline"),
          color: Colors.blue,
          points: polylinesLatLng,
        ));

        setState(() {
          polylines = _polylines;
        });
      }
    }
  }

  void drawPin(LatLng? latLng, String id) {
    markers.removeWhere((element) {
      return element.markerId == MarkerId(id);
    });
    if (latLng != null) {
      markers.add(
        Marker(
          markerId: MarkerId(id),
          position: latLng,
        ),
      );
    }
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
    polylinePoints = PolylinePoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                    newGoogleMapController = controller;
                    LatLng _latLng = LatLng(
                        state.position.latitude, state.position.longitude);
                    // use google sdk to search for place.
                    /*setState(() {srcSearchResult = _latLng});*/
                    mapAnimateToTarget(_latLng);
                  },
                  zoomGesturesEnabled: true,
                  /*zoomControlsEnabled: true,*/
                ),
                /*srcSearchResult != null && destSearchResult != null*/
                /*? ResultCard()*/
                /*: const SizedBox.shrink(),*/
                destSearchResult == null
                    ? SearchCard(
                        flutterGooglePlacesSdk: flutterGooglePlacesSdk,
                        srcSearchResult: srcSearchResult,
                        destSearchResult: destSearchResult,
                        updateSrcSearchResult: (result) {
                          setState(() {
                            srcSearchResult = result;
                          });
                        },
                        updateDestSearchResult: (result) {
                          setState(() {
                            destSearchResult = result;
                          });
                        },
                        mapHook: mapHook,
                      )
                    : ResultCard(),
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
      bottomNavigationBar: srcSearchResult != null && destSearchResult != null
          ? BottomAppBar(
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
            )
          : const SizedBox.shrink(),
    );
  }
}
