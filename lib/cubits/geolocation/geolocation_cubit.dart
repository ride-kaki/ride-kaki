import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

part 'geolocation_state.dart';

class GeolocationCubit extends Cubit<GeolocationState> {
  GeolocationCubit() : super(GeolocationLoading());

  late final Position _position;
  late bool _hasRequestedPosition = false;

  Future<void> requestPosition(BuildContext buildContext) async {
    bool serviceEnabled;
    LocationPermission permission;
    if (_hasRequestedPosition) {
      return;
    }

    _hasRequestedPosition = true;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      emit(GeolocationError('Location services are disabled.'));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        emit(GeolocationError('Location permissions are denied'));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      emit(GeolocationError(
          'Location permissions are permanently denied, we cannot request permissions.'));
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    emit(GeolocationLoaded(position: _position));
  }
}
