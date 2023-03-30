import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ride_kaki/models/price_result.dart';
import 'package:ride_kaki/models/waypoints.dart';
import 'package:ride_kaki/services/price_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import '../lib/utils/global_variables.dart';

void main() {
  test("price service returns same result", () async {
    // Arrange
    WayPoints wayPoints = WayPoints(
        starting_latitude: "1.428507",
        starting_longitude: "103.836154",
        ending_latitude: "1.302838",
        ending_longitude: "103.83496");
    PriceResult priceResult = PriceResult(
        gojek_4_economy_price: 0,
        gojek_6_economy_price: 0,
        gojek_4_premium_price: 0,
        tada_4_economy_price: 0,
        tada_6_economy_price: 0,
        tada_4_premium_price: 0);
    try {
      http.Response res = await http.post(
          Uri.parse('$uri/ridekaki/v1/RideKaki'),
          body: json.encode(wayPoints.toJson()));
      priceResult = PriceResult.fromJson(jsonDecode(res.body));
    } catch (e) {}

    // Act
    PriceResult result =
        await PriceService.getPrices(MockBuildContext(), wayPoints);

    //Assert
    expect(result.toJson(), priceResult.toJson());
  });
}

class MockBuildContext extends Mock implements BuildContext {}
