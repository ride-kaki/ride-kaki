import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ride_kaki/screens/promocode/promo_screen.dart';
import 'package:ride_kaki/screens/promocode/promocard.dart';

main() async {
  testWidgets("Promoscreen app bar displays Promo Codes", (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PromoScreen(),
      ),
    ));

    expect(find.text("Promo Codes"), findsOneWidget);

  });
}
