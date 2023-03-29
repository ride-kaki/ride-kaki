// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ride_kaki/screens/home/result_card_item.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() async {
  const String company = "JustGrab";
  const String location = "Lazada Building Exit B";
  const String logoUrl =
      "https://assets.grab.com/wp-content/uploads/sites/4/2021/04/15151634/Grab_Logo_2021.jpg";
  const double price = 16.69;

  testWidgets("ResultCardItem displays correct information",
      (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      //init widget
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: ResultCardItem(
                  company: company,
                  location: location,
                  price: price,
                  logoUrl: logoUrl,
                  onTap: (i) {},
                  index: 0,
                  isSelected: false))));
                  

      //Execute test

      //check outputs
      expect(find.text("JustGrab"), findsOneWidget);
      expect(find.text("Lazada Building Exit B"), findsOneWidget);
      expect(
          find.image(const NetworkImage(
              "https://assets.grab.com/wp-content/uploads/sites/4/2021/04/15151634/Grab_Logo_2021.jpg")),
          findsOneWidget);
      expect(find.text("S\$16.69"), findsOneWidget);
    });
  });

  testWidgets("ResultCardItem onTap function is called when tapped",
      (WidgetTester tester) async {
    //Test variable
    int idx = -1;

    //init widgets
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ResultCardItem(
                company: company,
                location: location,
                price: price,
                logoUrl: logoUrl,
                onTap: (i) {
                  idx = 1;
                },
                index: 0,
                isSelected: false))));

    //Execute test
    await tester.tap(find.byType(ListTile));

    //check outputs
    expect(idx, equals(1));
  });
}
