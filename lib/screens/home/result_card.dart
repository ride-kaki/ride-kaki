import 'package:flutter/material.dart';
import 'package:ride_kaki/screens/home/result_card_item.dart';
import 'package:ride_kaki/utils/formats.dart';

class ResultCard extends StatelessWidget {
  ResultCard({super.key});

  String company = "JustGrab";
  String location = "Lazada Building Exit B";
  String logoUrl =
      "https://assets.grab.com/wp-content/uploads/sites/4/2021/04/15151634/Grab_Logo_2021.jpg";
  double price = 16.69;

  DraggableScrollableController scrollController =
      DraggableScrollableController();

  void onTap() {
    print("Button was clicked");
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: scrollController,
      initialChildSize: 0.35,
      minChildSize: 0.1,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
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
                    borderRadius: BorderRadius.all(Radius.circular(15)),
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
                      onTap: onTap);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
