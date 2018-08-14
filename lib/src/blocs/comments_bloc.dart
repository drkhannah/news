import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resource/repository.dart';

class CommentsBloc {
  final Repository _repository = Repository();

  // A Subjects are similar to StreamControllers
  // but with added functionality
  final PublishSubject<int> _commentsFetcher = PublishSubject<int>();
  final BehaviorSubject<Map<int, Future<ItemModel>>> _commentsOutput =
      BehaviorSubject<Map<int, Future<ItemModel>>>();

  // Getters for streams
  Observable<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentsOutput.stream;

  // Getters for sinks
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    // transform every event in the _commentsFetcher stream
    // and pipe (forward) it into the _commentsOutput stream
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (Map<int, Future<ItemModel>> cache, int id, int index) {
        print(index);
        cache[id] = _repository.fetchItem(id);
        // recursively get all comments
        cache[id].then((ItemModel item) {
          item.kids.forEach((kidId) => fetchItemWithComments(kidId));
        });
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  // standard stream cleanup
  void dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
