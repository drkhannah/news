import 'dart:convert';

class ItemModel {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
  final List<dynamic> kids;
  final String url;
  final int score;
  final String title;
  final int descendants;

  ItemModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        deleted = parsedJson['deleted'] ?? false,
        type = parsedJson['type'],
        by = parsedJson['by'] ?? '',
        time = parsedJson['time'],
        text = parsedJson['text'] ?? '',
        dead = parsedJson['dead'] ?? false,
        parent = parsedJson['parent'],
        kids = parsedJson['kids'] ?? [],
        url = parsedJson['url'],
        score = parsedJson['score'],
        title = parsedJson['title'],
        descendants = parsedJson['descendants'] ?? 0;

  ItemModel.fromDB(Map<String, dynamic> dbMaps)
      : id = dbMaps['id'],
        deleted = dbMaps['deleted'] == 1,
        type = dbMaps['type'],
        by = dbMaps['by'],
        time = dbMaps['time'],
        text = dbMaps['text'],
        dead = dbMaps['dead'] == 1,
        parent = dbMaps['parent'],
        kids = jsonDecode(dbMaps['kids']),
        url = dbMaps['url'],
        score = dbMaps['score'],
        title = dbMaps['title'],
        descendants = dbMaps['descendants'];

  Map<String, dynamic> toSqlMap() {
    return <String, dynamic>{
      'id': id,
      'deleted': deleted ? 1 : 0,
      'type': type,
      'by': by,
      'time': time,
      'text': text,
      'dead': dead ? 1 : 0,
      'parent': parent,
      'kids': jsonEncode(kids),
      'url': url,
      'score': score,
      'title': title,
      'descendants': descendants,
    };
  }
}
