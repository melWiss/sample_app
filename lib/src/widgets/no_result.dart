import 'package:flutter/material.dart';

/// This widget appears when there's no result.
class NoResultWidget extends StatelessWidget {
  const NoResultWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.search_off,
          size: MediaQuery.of(context).size.width * .3,
          color: Colors.grey,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "No Result has been found",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
