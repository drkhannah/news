import 'package:flutter/material.dart';
import 'blocs/comments_provider.dart';
import 'screens/news_detail.dart';
import 'blocs/stories_provider.dart';
import 'blocs/comments_bloc.dart';
import 'screens/news_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News',
          onGenerateRoute: (RouteSettings settings) {
            return routes(settings);
          },
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(builder: (BuildContext context) {
        final StoriesBloc storiesBloc = StoriesProvider.of(context);
        storiesBloc.fetchTopIds();
        return NewsList();
      });
    } else {
      return MaterialPageRoute(builder: (BuildContext context) {
        final itemId = int.parse(settings.name.replaceFirst('/', ''));
        final CommentsBloc commentsBloc = CommentsProvider.of(context);
        commentsBloc.fetchItemWithComments(itemId);
        return NewsDetail(itemId: itemId);
      });
    }
  }
}
