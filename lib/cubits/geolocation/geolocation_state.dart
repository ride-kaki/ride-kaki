part of 'geolocation_cubit.dart';

@immutable
abstract class GeolocationState {}

class GeolocationLoading extends GeolocationState {}

class GeolocationLoaded extends GeolocationState {
  final Position position;
  GeolocationLoaded({
    required this.position,
  });
}

class GeolocationError extends GeolocationState {
  final String message;

  GeolocationError(this.message);
}
