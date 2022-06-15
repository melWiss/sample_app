import 'dart:async';

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
  int waitingTurn = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchTextController.addListener(() {
      waitingTurn++;
      Timer(Duration(seconds: 3), (() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          if (!emptyTextField)
            Expanded(
              child: StreamWidget<List<Location>>(
                stream: startingPointBloc.stream,
                onResult: (context, locations) {
                  return ListView.builder(
                    itemCount: locations!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(locations[index].name ?? ""),
                      );
                    },
                  );
                },
                onError: (error) {
                  StartingPointException exception =
                      error as StartingPointException;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.red,
                        child: const Text(
                          "Error has occured",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: exception.cachedLocations.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  exception.cachedLocations[index].name ?? ""),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          if (emptyTextField)
            const Expanded(
              child: Center(
                child: Text("Please fill in the search field."),
              ),
            )
        ],
      ),
    );
  }
}
