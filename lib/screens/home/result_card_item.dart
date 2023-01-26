import 'package:flutter/material.dart';
import 'package:ride_kaki/utils/formats.dart';

class ResultCardItem extends StatelessWidget {
  String company;
  String location;
  String logoUrl;
  double price;
  void Function() onTap;

  ResultCardItem({
    super.key,
    required this.company,
    required this.location,
    required this.price,
    required this.logoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Image.network(logoUrl),
      ),
      // horizontalTitleGap: 5,
      title: Text(
        company,
      ),
      subtitle: Text(
        location,
      ),
      trailing: Text(
        formatMoney.format(price),
      ),
    );
  }
}
