import 'package:flutter/material.dart';

/// FutureWidget is an equivalent for FutureBuilder with the goal of reducing
/// FutureBuilder's boiler plate code (like handling the state of error and
/// waiting for results).
class FutureWidget<T> extends StatelessWidget {
  final Future<T>? future;
  final Widget Function(BuildContext context, T? data)? onResult;
  final Widget Function(Object? error)? onError;
  final Widget Function()? onWait;
  const FutureWidget({
    Key? key,
    this.future,
    this.onResult,
    this.onError,
    this.onWait,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return onResult!(context, snapshot.data);
        } else if (snapshot.hasError) {
          if (onError == null) {
            return Center(
              child: Text("Error while loading data:\n${snapshot.error}"),
            );
          } else {
            return onError!(snapshot.error);
          }
        } else {
          if (onWait == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return onWait!();
          }
        }
      },
    );
  }
}
