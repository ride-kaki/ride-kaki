import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_kaki/cubits/supabase/history_cubit.dart';
import 'package:ride_kaki/models/history.dart';
import 'package:ride_kaki/screens/home/search_button.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as google_places_sdk;
import 'package:ride_kaki/screens/promocode/promo_screen.dart';
import 'package:ride_kaki/screens/search/places_search_delegate.dart';
import 'package:ride_kaki/supabase/snackbar.dart';
import 'package:ride_kaki/utils/constants.dart';

class SearchCard extends StatefulWidget {
  google_places_sdk.FlutterGooglePlacesSdk flutterGooglePlacesSdk;
  google_places_sdk.Place? srcSearchResult;
  google_places_sdk.Place? destSearchResult;
  void Function(google_places_sdk.Place?) updateSrcSearchResult;
  void Function(google_places_sdk.Place?) updateDestSearchResult;
  void Function(bool, LatLng?, LatLng?) mapHook;

  String username = "Sophia";

  SearchCard({
    super.key,
    required this.flutterGooglePlacesSdk,
    required this.srcSearchResult,
    required this.destSearchResult,
    required this.updateSrcSearchResult,
    required this.updateDestSearchResult,
    required this.mapHook,
  });

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  DraggableScrollableController scrollController =
      DraggableScrollableController();

  

  // isUpdateDest is a boolean flag that if is true, denotes that we're updating
  // the destination, otherwise we're updating the src
  onTap(bool isUpdateDest, String? address) async {
    google_places_sdk.Place? prevSearchResult =
        isUpdateDest ? widget.destSearchResult : widget.srcSearchResult;

    String prevSearchResultStr = address ?? "";
    if (address == null) {
      address = prevSearchResult == null ? "" : prevSearchResult!.address;
    }

    google_places_sdk.Place? result =
        await showSearch<google_places_sdk.Place?>(
      context: context,
      delegate: PlacesSearchDelegate(
        searchFieldPlaceholder: "Search for your location",
        flutterGooglePlacesSdk: widget.flutterGooglePlacesSdk,
        previousSearchResult: prevSearchResultStr,
      ),
    );

    if (result != null) {
      History h = History(
        userId: supabase.auth.currentUser!.id,
        search: result.address!,
      );
      context.read<HistoryCubit>().addHistory(h);
    }

    // set state is async, so we want to animate when the states are done setting
    // so these are local vars to track states
    LatLng? _src = widget.srcSearchResult == null
        ? null
        : LatLng(widget.srcSearchResult!.latLng!.lat,
            widget.srcSearchResult!.latLng!.lng);

    LatLng? _dest = widget.destSearchResult == null
        ? null
        : LatLng(widget.destSearchResult!.latLng!.lat,
            widget.destSearchResult!.latLng!.lng);

    // update the states and local vars
    if (isUpdateDest) {
      _dest = result == null
          ? null
          : LatLng(result.latLng!.lat, result.latLng!.lng);

      widget.updateDestSearchResult(result);
    } else {
      _src = result == null
          ? null
          : LatLng(result.latLng!.lat, result.latLng!.lng);
      widget.updateSrcSearchResult(result);
    }

    widget.mapHook(
      isUpdateDest,
      _src,
      _dest,
    );
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: scrollController,
      initialChildSize: 0.35,
      minChildSize: 0.35,
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
                height: 15,
              ),
              // start of the card body
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, ${widget.username}",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          flex: 7,
                          // child: FractionallySizedBox(
                          //   widthFactor: 0.90,
                          child: SearchButton(
                              key: const Key("searchBar"),
                              onTap: () {
                                onTap(widget.srcSearchResult != null, null);
                              },
                              locationText: 'Where are you heading?'),
                          // ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Recent Searches",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    BlocBuilder<HistoryCubit, HistoryState>(
                        builder: (context, state) {
                      if (state is HistoryLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is HistoryLoaded) {
                        return ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final String search =
                                  state.currentHistory[index].search;
                              return ListTile(
                                title: Text(search),
                                leading: Icon(
                                  Icons.history,
                                  color: Colors.grey,
                                ),
                                onTap: () {
                                  onTap(widget.srcSearchResult != null, search);
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: state.currentHistory.length);
                      } else {
                        return SizedBox.shrink();
                      }
                    })
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
