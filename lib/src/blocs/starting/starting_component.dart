import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/src/blocs/starting/starting_bloc.dart';
import 'package:sample_app/src/blocs/starting/starting_exception.dart';
import 'package:sample_app/src/models/models.dart';
import 'package:sample_app/src/widgets/widgets.dart';

class StartingPointComponent extends StatefulWidget {
  const StartingPointComponent({Key? key}) : super(key: key);

  @override
  State<StartingPointComponent> createState() => _StartingPointComponentState();
}

class _StartingPointComponentState extends State<StartingPointComponent> {
  TextEditingController searchTextController = TextEditingController();
  bool firstTime = true;
  bool noConnectivity = false;
  bool showYesConnectivity = false;
  int waitingTurn = 0;
  Location? selectedLocation;

  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  @override
  void initState() {
    super.initState();
    searchTextController.addListener(() {
      waitingTurn++;
      Timer(
        const Duration(seconds: 1),
        (() {
          if (--waitingTurn == 0) {
            setState(() {
              if (searchTextController.text.isNotEmpty) {
                startingPointBloc.showCircularProgressIndicator();
                startingPointBloc.searchLocation(searchTextController.text);
                firstTime = false;
              }
            });
          }
        }),
      );
    });

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.ethernet:
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
          {
            setState(() {
              noConnectivity = false;
              if (searchTextController.text.isNotEmpty) {
                startingPointBloc.searchLocation(searchTextController.text);
              }
              showYesConnectivity = true;
            });
            Timer(const Duration(seconds: 3), () {
              setState(() {
                showYesConnectivity = false;
              });
            });
          }
          break;
        default:
          setState(() {
            noConnectivity = true;
          });
      }
    });
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 8.0,
              ),
              child: TextField(
                controller: searchTextController,
                decoration: const InputDecoration(
                  labelText: "Search Field",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            if (noConnectivity)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(4),
                color: Colors.red,
                child: const Text(
                  "No Internet Connectivity",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            if (!noConnectivity && showYesConnectivity)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(4),
                color: Colors.green,
                child: const Text(
                  "Internet Connectivity Is Established",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            if (!firstTime)
              Expanded(
                child: StreamWidget<List<Location>?>(
                  stream: startingPointBloc.stream,
                  onResult: (context, locations) =>
                      renderLocationsList(locations!),
                  onError: (error) {
                    StartingPointException exception =
                        error as StartingPointException;
                    return renderLocationsList(exception.cachedLocations);
                  },
                ),
              ),
            if (firstTime)
              const Expanded(
                child: Center(
                  child: Text("Write Something into the search field."),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget renderLocationsList(List<Location> locations) {
    if (locations.isNotEmpty) {
      return ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                selected: locations[index] == selectedLocation,
                onTap: () {
                  setState(() {
                    if (locations[index] != selectedLocation) {
                      selectedLocation = locations[index];
                    } else {
                      selectedLocation = null;
                    }
                  });
                },
                title: Text(locations[index].name ?? ""),
                subtitle: Text(
                    "Type: ${locations[index].type?.toUpperCase()}, Locality: ${locations[index].isBest}"),
              ),
            ),
          );
        },
      );
    } else {
      return const NoResultWidget();
    }
  }
}
