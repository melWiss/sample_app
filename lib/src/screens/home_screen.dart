import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sample_app/src/blocs/starting/starting_component.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String route = "/";
  @override
  Widget build(BuildContext context) {
    return const StartingPointComponent();
  }
}
