import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ride_kaki/screens/home/search_button.dart';

main() async {
  testWidgets("SearchBar displays text correctly", (widgetTester) async {
    //Arrange
    await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: SearchButton(onTap: () {}, locationText: "SMU School of econs"),
    )));

    //Act

    //Assert
    expect(find.text("SMU School of econs"), findsOneWidget);
  });
}
