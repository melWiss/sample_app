import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/src/blocs/starting/starting_api_repository.dart';
import 'package:sample_app/src/blocs/starting/starting_bloc.dart';
import 'package:sample_app/src/blocs/starting/starting_cache_repository.dart';
import 'package:sample_app/src/blocs/starting/starting_exception.dart';
import 'package:sample_app/src/models/models.dart';
import 'package:sample_app/src/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String route = "/";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchTextController = TextEditingController();
  bool emptyTextField = true;
  bool noConnectivity = false;
  bool showYesConnectivity = false;
  int waitingTurn = 0;

  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchTextController.addListener(() {
      waitingTurn++;
      Timer(Duration(seconds: 2), (() {
        if (--waitingTurn == 0) {
          setState(() {
            if (searchTextController.text.isEmpty) {
              emptyTextField = true;
            } else {
              emptyTextField = false;
              startingPointBloc.searchLocation(searchTextController.text);
            }
          });
        }
      }));
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
            Timer(Duration(seconds: 3), () {
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
    // TODO: implement dispose
    connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    Radius.circular(25),
                  ),
                ),
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
          Expanded(
            child: StreamWidget<List<Location>>(
              stream: startingPointBloc.stream,
              onResult: (context, locations) => renderLocationsList(locations!),
              onError: (error) {
                StartingPointException exception =
                    error as StartingPointException;
                return renderLocationsList(exception.cachedLocations);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget renderLocationsList(List<Location> locations) {
    if (locations.isNotEmpty) {
      return ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(locations[index].name ?? ""),
          );
        },
      );
    } else {
      return const Center(
        child: Text("No Result has been found"),
      );
    }
  }
}
