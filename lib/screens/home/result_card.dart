import 'package:flutter/material.dart';
import 'package:ride_kaki/models/price_result.dart';
import 'package:ride_kaki/models/result.dart';
import 'package:ride_kaki/models/waypoints.dart';
import 'package:ride_kaki/screens/home/result_card_item.dart';
import 'package:ride_kaki/services/price_service.dart';
import 'package:ride_kaki/utils/formats.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as google_places_sdk;

class ResultCard extends StatefulWidget {
  // TODO: add parameter for List of Rides
  // String? company = "JustGrab";
  // String? location = "Lazada Building Exit B";
  // String? logoPath = "assets/images/gojek.png";
  // double? price = 16.69;
  google_places_sdk.Place srcSearchResult;
  google_places_sdk.Place destSearchResult;

  ResultCard(
      {super.key,
      required this.srcSearchResult,
      required this.destSearchResult});

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  List<Result> results = [];

  int selectedIndex = -1;

  DraggableScrollableController scrollController =
      DraggableScrollableController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PriceService.getResults(
            context,
            WayPoints(
                starting_latitude:
                    widget.srcSearchResult.latLng!.lat.toString(),
                starting_longitude:
                    widget.srcSearchResult.latLng!.lng.toString(),
                ending_latitude: widget.destSearchResult.latLng!.lat.toString(),
                ending_longitude:
                    widget.destSearchResult.latLng!.lng.toString()))
        .then((value) {
      setState(() {
        results = value;
      });
    });
  }

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
    results.sort(((a, b) => a.price!.compareTo(b.price!)));

    return DraggableScrollableSheet(
      controller: scrollController,
      initialChildSize: 0.33,
      minChildSize: 0.33,
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
                      Radius.circular(100),
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
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  String logoPath = "";
                  if (results[index].rideName!.split(" ")[0] == "TADA") {
                    logoPath = "assets/images/tada.png";
                  } else if (results[index].rideName!.split(" ")[0] ==
                      "Gojek") {
                    logoPath = "assets/images/gojek.png";
                  }
                  return ResultCardItem(
                    company: results[index].rideName!,
                    location: widget.destSearchResult.address!,
                    price: results[index].price!,
                    logoPath: logoPath,
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
