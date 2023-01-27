import 'package:flutter/material.dart';
import 'package:ride_kaki/screens/home/result_card_item.dart';
import 'package:ride_kaki/utils/formats.dart';

class ResultCard extends StatefulWidget {
  // TODO: add parameter for List of Rides
  ResultCard({super.key});

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  static const String company = "JustGrab";
  static const String location = "Lazada Building Exit B";
  static const String logoUrl =
      "https://assets.grab.com/wp-content/uploads/sites/4/2021/04/15151634/Grab_Logo_2021.jpg";
  static const double price = 16.69;

  int selectedIndex = -1;

  DraggableScrollableController scrollController =
      DraggableScrollableController();

  void onTap(int index) {
    int newIndex = index;
    if (index == selectedIndex) {
      newIndex = -1;
    }
    setState(() {
      selectedIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: scrollController,
      initialChildSize: 0.35,
      minChildSize: 0.20,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 0.25)),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            children: [
              const SizedBox(
                height: 20,
              ),
              FractionallySizedBox(
                widthFactor: 0.10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Colors.grey.shade300,
                  ),
                  child: const SizedBox(
                    height: 5,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 20,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemBuilder: (context, index) {
                  return ResultCardItem(
                    company: company,
                    location: location,
                    price: price,
                    logoUrl: logoUrl,
                    index: index,
                    isSelected: index == selectedIndex,
                    onTap: onTap,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
