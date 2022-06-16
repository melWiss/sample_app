import 'package:flutter/material.dart';

/// StreamWidget is an equivalent for StreamBuilder with the goal of reducing
/// StreamBuilder's boiler plate code (like handling the state of error and
/// waiting for results).
class StreamWidget<T> extends StatelessWidget {
  final Stream<T>? stream;
  final Widget Function(BuildContext context, T? data)? onResult;
  final Widget Function(Object? error)? onError;
  final Widget Function()? onWait;
  const StreamWidget({
    Key? key,
    this.stream,
    this.onResult,
    this.onError,
    this.onWait,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
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
