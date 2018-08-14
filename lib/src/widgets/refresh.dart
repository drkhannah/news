import 'package:flutter/material.dart';
import '../blocs/stories_bloc.dart';
import '../blocs/stories_provider.dart';

class Refresh extends StatelessWidget {
  final Widget child;

  Refresh({this.child});

  @override
  Widget build(BuildContext context) {
    final StoriesBloc bloc = StoriesProvider.of(context);
    return RefreshIndicator(
      child: this.child,
      onRefresh: () async {
        await bloc.purgeCache();
        await bloc.fetchTopIds();
      },
    );
  }
}
