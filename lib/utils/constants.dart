import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String gMapsAPIKey = dotenv.get('GMAPS_API_KEY', fallback: 'INVALID_KEY');

/// Initial value that is used for the locale
const gMapsPlacesLocale = Locale('en');
