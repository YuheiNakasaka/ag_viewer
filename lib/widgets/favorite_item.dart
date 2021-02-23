import 'package:ag_viewer/blocs/ag_bloc.dart';
import 'package:ag_viewer/constants.dart';
import 'package:ag_viewer/models/favorite_object.dart';
import 'package:ag_viewer/models/program_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteItem extends StatefulWidget {
  const FavoriteItem(this.program);

  final ProgramObject program;

  @override
  _FavoriteItemState createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<FavoriteItem> {
  AgBloc _agBloc;

  @override
  void initState() {
    super.initState();
    _agBloc = context.read<AgBloc>(agProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Constants.baseColor,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 76,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                  child: RichText(
                    text: TextSpan(
                      text: widget.program.hhmm(),
                      style: TextStyle(
                        color: _labelColor(),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: ' ${widget.program.isRepeat ? '[再]' : '[初回]'}',
                          style: TextStyle(
                            color: _labelColor(),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.program.title,
                          style: TextStyle(
                            color: Constants.activeColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 0, 8),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.program.pfm,
                          style: TextStyle(
                            color: Constants.activeColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<List<FavoriteObject>>(
            stream: _agBloc.outFavorites,
            builder: (BuildContext context,
                AsyncSnapshot<List<FavoriteObject>> snapshot) {
              if (!snapshot.hasData || snapshot.data.isEmpty) {
                return IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Constants.mainColor,
                  ),
                  onPressed: () {
                    _agBloc.addFavorite(widget.program);
                  },
                );
              }
              return Align(
                child: snapshot.data
                        .where((e) => e.isEqualTo(widget.program))
                        .isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Constants.acccentColor,
                        ),
                        onPressed: () {
                          _agBloc.deleteFavorite(widget.program);
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Constants.mainColor,
                        ),
                        onPressed: () {
                          _agBloc.addFavorite(widget.program);
                        },
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _labelColor() {
    final now = DateTime.now();
    return widget.program.from.isBefore(now) && widget.program.to.isAfter(now)
        ? Constants.acccentColor
        : Constants.activeColor;
  }
}
