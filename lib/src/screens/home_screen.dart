import 'package:flutter/material.dart';
import 'package:sample_app/src/blocs/starting/starting_component.dart';

/// First screen that appears.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String route = "/";
  @override
  Widget build(BuildContext context) {
    return const StartingPointComponent();
  }
}
