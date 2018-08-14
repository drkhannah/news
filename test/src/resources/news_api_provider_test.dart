import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

import 'package:news/src/resource/news_api_provider.dart';

final mockIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
final itemResponse = {'id': 123};

void main() {
  test('getTopIds() returns a list of ids', () async {
    final newsApi = NewsApiProvider();

    // replace NewsApiProvider.client with MockClient
    newsApi.client =
        MockClient((request) async => Response(json.encode(mockIds), 200));

    final ids = await newsApi.fetchTopIds();

    expect(ids, mockIds);
  });

  test('getItem() returns a ItemModel', () async {
    final newsApi = NewsApiProvider();

    // replace NewsApiProvider.client with MockClient
    newsApi.client =
        MockClient((request) async => Response(json.encode(itemResponse), 200));

    final item = await newsApi.fetchItem(1);

    expect(item.id, 123);
  });
}
