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
  List<Result> results4 = [];
  List<Result> results6 = [];
  bool is4Seater = true;
  int selectedIndex = -1;
  bool vertical = false;
  final List<bool> _selectedSeat = <bool>[true, false];

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
        List<Result> res4 = [];
        List<Result> res6 = [];

        for (var item in value) {
          if (item.rideName!.split(" ")[item.rideName!.split(" ").length - 1] ==
              "4") {
            res4.add(item);
          } else {
            res6.add(item);
          }
        }
        results4 = res4;
        results6 = res6;
      });
    });
  }

  //This helps to update the price when src/dest changes
  @override
  void didUpdateWidget(covariant ResultCard oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
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
        List<Result> res4 = [];
        List<Result> res6 = [];

        for (var item in value) {
          if (item.rideName!.split(" ")[item.rideName!.split(" ").length - 1] ==
              "4") {
            res4.add(item);
          } else {
            res6.add(item);
          }
        }
        results4 = res4;
        results6 = res6;
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
    results4.sort(((a, b) => a.price!.compareTo(b.price!)));
    results6.sort(((a, b) => a.price!.compareTo(b.price!)));

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
              Center(
                child: ToggleButtons(
                  direction: vertical ? Axis.vertical : Axis.horizontal,
                  onPressed: (int index) {
                    setState(() {
                      is4Seater = index == 0 ? true : false;
                      for (var i = 0; i < _selectedSeat.length; i++) {
                        _selectedSeat[i] = i == index; 
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.green[700],
                  selectedColor: Colors.white,
                  fillColor: Colors.green[200],
                  color: Colors.green[400],
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 140,
                  ),
                  isSelected: _selectedSeat,
                  children: const <Widget>[Text("4 Seater"), Text("6 Seater")]
                ),
              ),
              is4Seater ?
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: results4.length,
                itemBuilder: (context, index) {
                  return ResultCardItem(
                    company: results4[index].rideName!,
                    location: widget.destSearchResult.address!,
                    price: results4[index].price!,
                    logoPath:
                        "assets/images/${results4[index].rideName!.split(" ")[0].toLowerCase()}.png",
                    index: index,
                    isSelected: index == selectedIndex,
                    onTap: onTap,
                  );
                },
              ) : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: results6.length,
                itemBuilder: (context, index) {
                  return ResultCardItem(
                    company: results6[index].rideName!,
                    location: widget.destSearchResult.address!,
                    price: results6[index].price!,
                    logoPath:
                        "assets/images/${results6[index].rideName!.split(" ")[0].toLowerCase()}.png",
                    index: index,
                    isSelected: index == selectedIndex,
                    onTap: onTap,
                  );
                },
              ) 
            ],
          ),
        );
      },
    );
  }
}
