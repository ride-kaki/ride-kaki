import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ride_kaki/models/waypoints.dart';
import '../models/price_result.dart';
import '../utils/global_variables.dart';

class PriceService {
  static Future<PriceResult> getPrices(
      BuildContext context, WayPoints wayPoints) async {
    PriceResult priceResult = PriceResult(
        gojek_4_economy_price: null,
        gojek_4_premium_price: null,
        gojek_6_economy_price: null,
        tada_4_economy_price: null,
        tada_4_premium_price: null,
        tada_6_economy_price: null);
    try {
      http.Response res =
          await http.post(Uri.parse('$uri/ridekaki/v1/RideKaki'), body: json.encode(wayPoints.toJson()));


      priceResult = PriceResult.fromJson(jsonDecode(res.body));
    } catch (e) {
      print(e);

    }

    return priceResult;
  }
}
