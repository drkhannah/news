import 'dart:async';

import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resource/repository.dart';

class StoriesBloc {
  final Repository _repository = Repository();

  // A Subjects are similar to StreamControllers
  // but with added functionality
  final PublishSubject<List<int>> _topIds = PublishSubject<List<int>>();
  final BehaviorSubject<Map<int, Future<ItemModel>>> _itemsOutput =
      BehaviorSubject<Map<int, Future<ItemModel>>>();
  final PublishSubject<int> _itemsFetcher = PublishSubject<int>();

  // Getters for steams
  Observable<List<int>> get topIds => _topIds.stream;
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  // Getters for sinks
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
    // transform every event in the _itemsFetcher stream
    // and pipe (forward) it into the _itemsOutput stream
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  // get top IDs using the Repository
  // and add them to the _topIds sink
  Future<List<int>> fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  Future<int> purgeCache() {
    return _repository.purgeCache();
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, int index) {
        // print(index);
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  // standard stream cleanup
  void dispose() {
    _topIds.close();
    _itemsOutput.close();
    _itemsFetcher.close();
  }
}
