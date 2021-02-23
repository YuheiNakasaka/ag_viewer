import 'package:ag_viewer/blocs/ag_bloc.dart';
import 'package:ag_viewer/constants.dart';
import 'package:ag_viewer/models/favorite_object.dart';
import 'package:ag_viewer/widgets/favorite_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage();
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  AgBloc _agBloc;

  @override
  void initState() {
    super.initState();
    _agBloc = context.read<AgBloc>(agProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.bkColor,
      appBar: AppBar(
        backgroundColor: Constants.baseColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Constants.mainColor,
          ),
          padding: const EdgeInsets.all(0),
          iconSize: 28,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<List<FavoriteObject>>(
        stream: _agBloc.outFavorites,
        builder: (BuildContext context,
            AsyncSnapshot<List<FavoriteObject>> snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(
              child: Text(
                'お気に入りはまだありません',
                style: TextStyle(
                  color: Constants.activeColor,
                  fontSize: 16,
                ),
              ),
            );
          }
          final list = snapshot.data;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return FavoriteItem(list[index].program);
            },
          );
        },
      ),
    );
  }
}
