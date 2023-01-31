import 'package:flutter/material.dart';
import 'package:ride_kaki/screens/promocode/promo_card_gojek.dart';
import 'package:ride_kaki/screens/promocode/promo_card_grab.dart';

class PromoScreen extends StatefulWidget {
  const PromoScreen({Key? key}) : super(key: key);

  @override
  _PromoScreenState createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo Codes'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HorizontalCouponExample1(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HorizontalCouponExample1(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HorizontalCouponExample1(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HorizontalCouponExample1(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HorizontalCouponExample1(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HorizontalCouponExample2(),
          )
        ],
      ),
    );
  }
}
