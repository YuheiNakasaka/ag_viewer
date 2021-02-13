import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage();
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('favorite'),
      ),
    );
  }
}
