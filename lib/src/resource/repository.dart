import 'dart:async';

import '../models/item_model.dart';
import '../resource/news_api_provider.dart';
import '../resource/news_db_provider.dart';

class Repository {
  List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];
  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;

    // look for item in all sources
    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    // store item in cache
    for (var cache in caches) {
      if (cache != source) cache.addItem(item);
    }

    return item;
  }

  Future<int> purgeCache() async {
    for (var cache in caches) {
      await cache.purge();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> purge();
}
