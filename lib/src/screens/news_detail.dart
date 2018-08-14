import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/comments_provider.dart';
import '../widgets/comment.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;

  NewsDetail({this.itemId});

  @override
  Widget build(BuildContext context) {
    final CommentsBloc bloc = CommentsProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Story Details'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (
        BuildContext context,
        AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot,
      ) {
        if (!snapshot.hasData) {
          Text('loading...');
        }

        final Future<ItemModel> itemFuture = snapshot.data[itemId];

        return FutureBuilder(
          future: itemFuture,
          builder: (
            BuildContext context,
            AsyncSnapshot<ItemModel> itemSnapshot,
          ) {
            if (!itemSnapshot.hasData) {
              return Text('loading...');
            }
            return buildList(itemSnapshot.data, snapshot.data);
          },
        );
      },
    );
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final children = <Widget>[];
    children.add(buildTitle(item));

    final List<Comment> commentsList = item.kids.map((kidId) {
      return Comment(
        itemId: kidId,
        itemMap: itemMap,
        depth: 0,
      );
    }).toList();
    children.addAll(commentsList);

    return ListView(children: children);
  }

  Widget buildTitle(ItemModel item) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(10.0),
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
