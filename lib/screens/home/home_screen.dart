import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
  google_places_sdk.Place? srcSearchResult;
  google_places_sdk.Place? destSearchResult;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  late PolylinePoints polylinePoints;

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
        10.0,
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

  onPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PromoScreen(),
      ),
    );
  }

  // isUpdateDest is a boolean flag that if is true, denotes that we're updating
  // the destination, otherwise we're updating the src
  onTap(bool isUpdateDest) async {
    google_places_sdk.Place? prevSearchResult =
        isUpdateDest ? destSearchResult : srcSearchResult;

    google_places_sdk.Place? result =
        await showSearch<google_places_sdk.Place?>(
      context: context,
      delegate: PlacesSearchDelegate(
        searchFieldPlaceholder: "Search for your location",
        flutterGooglePlacesSdk: flutterGooglePlacesSdk,
        previousSearchResult:
            prevSearchResult == null ? '' : prevSearchResult.address!,
      ),
    );

    // set state is async, so we want to animate when the states are done setting
    // so these are local vars to track states
    LatLng? _src = srcSearchResult == null
        ? null
        : LatLng(srcSearchResult!.latLng!.lat, srcSearchResult!.latLng!.lng);

    ;
    LatLng? _dest = destSearchResult == null
        ? null
        : LatLng(destSearchResult!.latLng!.lat, destSearchResult!.latLng!.lng);

    // update the states and local vars
    if (isUpdateDest) {
      _dest = result == null
          ? null
          : LatLng(result.latLng!.lat, result.latLng!.lng);

      setState(() {
        destSearchResult = result;
      });
    } else {
      _src = result == null
          ? null
          : LatLng(result.latLng!.lat, result.latLng!.lng);
      setState(() {
        srcSearchResult = result;
      });
    }

    // draw pins
    drawPin(
      isUpdateDest ? _dest : _src,
      isUpdateDest ? 'destinationPin' : 'sourcePin',
    );

    // check if the result selected was null
    if (result != null && result.latLng != null) {
      // if both locations are filled in
      if (_dest != null && _src != null) {
        // draw polylines
        drawPolylines(
          _src,
          _dest,
        );
        // animate to boundary locations
        mapAnimateToBounds(_src, _dest);
      }
      // if the result isn't empty and there is 1 location filled, animate to 1 location
      else if (_dest == null || _src == null) {
        LatLng _result = LatLng(result.latLng!.lat, result.latLng!.lng);

        drawPolylines(
          _src,
          _dest,
        );
        // animate to single location
        mapAnimateToTarget(isUpdateDest ? _dest! : _src!);
      }

      // initialise markers
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        toolbarHeight: 160,
        centerTitle: true,
        title: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 7,
                  // child: FractionallySizedBox(
                  //   widthFactor: 0.90,
                  child: SearchButton(
                    iconData: Icons.hail,
                    onTap: () {
                      onTap(false);
                    },
                    locationText: srcSearchResult == null
                        ? 'Select your pickup point'
                        : srcSearchResult!.address!,
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
            const SizedBox(height: 20),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 7,
                  // child: FractionallySizedBox(
                  //   widthFactor: 0.90,
                  child: SearchButton(
                    iconData: Icons.location_pin,
                    onTap: () {
                      onTap(true);
                    },
                    locationText: destSearchResult == null
                        ? 'Select your destination'
                        : destSearchResult!.address!,
                  ),
                  // ),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Spacer(flex: 1),
              ],
            ),
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
                    LatLng _latLng = LatLng(
                        state.position.latitude, state.position.longitude);
                    mapAnimateToTarget(_latLng);
                  },
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                ),
                srcSearchResult == null && destSearchResult == null
                    ? const SizedBox.shrink()
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
      bottomNavigationBar: srcSearchResult == null
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
