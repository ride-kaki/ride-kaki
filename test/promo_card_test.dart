import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ride_kaki/screens/promocode/promocard.dart';

main() async {

  
  testWidgets("Promocard displays correct information", (widgetTester) async {
    //arrange
    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: PromoCard(
        promoDetails: "\$2 Off",
        promoCode: "CNY2020",
        lastRedemptionDate: DateTime.now().toString().substring(0, 10),
        imageString: "./assets/images/grab.png",
      ),
    )));

    //act

    //assert
    expect(find.text("\$2 Off"), findsOneWidget);
    expect(find.text("CNY2020"), findsOneWidget);

    expect(find.image(const AssetImage("./assets/images/grab.png")), findsOneWidget);
  });
}
