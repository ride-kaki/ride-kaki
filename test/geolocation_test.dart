import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:ride_kaki/cubits/geolocation/geolocation_cubit.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGeolocator extends Mock implements Geolocator {}

Position get mockPosition => Position(
    latitude: 52.561270,
    longitude: 5.639382,
    timestamp: DateTime.fromMillisecondsSinceEpoch(
      500,
      isUtc: true,
    ),
    altitude: 3000.0,
    accuracy: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('GeolocationCubit', () {
    late GeolocationCubit geolocationCubit;

    setUp(() {
      GeolocatorPlatform.instance = MockGeolocatorPlatform();
      geolocationCubit = GeolocationCubit();
    });

    test('emits GeolocationLoaded when everything is running', () async {
      await geolocationCubit.requestPosition(MockBuildContext());

      expect(geolocationCubit.state, isA<GeolocationLoaded>());
    });

    test('emits GeolocationLoaded when all conditions are met', () async {
      final position = Position(
          latitude: 52.561270,
          longitude: 5.639382,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            500,
            isUtc: true,
          ),
          altitude: 3000.0,
          accuracy: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0);

      await geolocationCubit.requestPosition(MockBuildContext());

      expect(
        geolocationCubit.state,
        isA<GeolocationLoaded>()
            .having((s) => s.position, 'position', position),
      );
    });
  });
}

class MockGeolocatorPlatform extends Mock
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        GeolocatorPlatform {
  @override
  Future<LocationPermission> checkPermission() =>
      Future.value(LocationPermission.whileInUse);

  @override
  Future<LocationPermission> requestPermission() =>
      Future.value(LocationPermission.whileInUse);

  @override
  Future<bool> isLocationServiceEnabled() => Future.value(false);

  @override
  Future<Position> getLastKnownPosition({
    bool forceLocationManager = false,
  }) =>
      Future.value(mockPosition);

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) =>
      Future.value(mockPosition);

  @override
  Stream<ServiceStatus> getServiceStatusStream() {
    return super.noSuchMethod(
      Invocation.method(
        #getServiceStatusStream,
        null,
      ),
      returnValue: Stream.value(ServiceStatus.enabled),
    );
  }
}



class MockBuildContext extends Mock implements BuildContext {}
