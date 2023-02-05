import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng latLngJurongGateway = LatLng(1.3327, 103.74355);
const LatLng latLngSMU = LatLng(1.2963, 103.8502);

const CameraPosition locationGooglePlex = CameraPosition(
  target: latLngSMU,
  zoom: 14.0,
);
