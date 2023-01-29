import 'package:flutter/material.dart';
import 'package:ride_kaki/utils/formats.dart';

class ResultCardItem extends StatelessWidget {
  String company;
  String location;
  String logoUrl;
  double price;
  int index;
  bool isSelected;

  void Function(int) onTap;
// TODO: add parameter for single Ride
  ResultCardItem({
    super.key,
    required this.company,
    required this.location,
    required this.price,
    required this.logoUrl,
    required this.onTap,
    required this.index,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey.shade200 : Colors.transparent,
      ),
      child: ListTile(
        onTap: () {
          onTap(index);
        },
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20,
              ),
            ),
          ),
          child: SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(
              "assets/images/grab.png",
            ),
          ),
        ),
        // horizontalTitleGap: 5,
        title: Text(
          company,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(
          location,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Text(
          formatMoney.format(price),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}
