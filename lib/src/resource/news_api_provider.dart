import 'dart:async';
import 'dart:convert';
import "package:http/http.dart" show Client;
import '../models/item_model.dart';
import 'repository.dart';

final String _baseURL = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  Client client = Client();

  @override
  Future<List<int>> fetchTopIds() async {
    final response = await client.get('$_baseURL/topstories.json');
    final ids = json.decode(response.body);
    return ids.cast<int>();
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get('$_baseURL/item/$id.json');
    final item = json.decode(response.body);
    return ItemModel.fromJson(item);
  }
}
