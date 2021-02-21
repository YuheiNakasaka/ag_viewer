import 'package:ag_viewer/blocs/ag_bloc.dart';
import 'package:ag_viewer/constants.dart';
import 'package:ag_viewer/models/favorite_object.dart';
import 'package:ag_viewer/models/program_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgramPage extends StatefulWidget {
  const ProgramPage();
  @override
  _ProgramPageState createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  AgBloc _agBloc;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _agBloc = context.read<AgBloc>(agProvider);
    _agBloc.initPrograms();
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
            Icons.settings,
            color: Constants.mainColor,
          ),
          padding: const EdgeInsets.all(0),
          iconSize: 28,
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Constants.mainColor,
            ),
            padding: const EdgeInsets.all(0),
            iconSize: 28,
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<List<List<ProgramObject>>>(
        stream: _agBloc.outPrograms,
        builder: (BuildContext context,
            AsyncSnapshot<List<List<ProgramObject>>> snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Container();
          }
          return DefaultTabController(
            length: snapshot.data.length,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Constants.bkColor,
                appBar: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Constants.activeColor,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  tabs: <Widget>[
                    _tab('月'),
                    _tab('火'),
                    _tab('水'),
                    _tab('木'),
                    _tab('金'),
                    _tab('土'),
                    _tab('日'),
                  ],
                ),
                body: TabBarView(
                  children: _tabViews(snapshot.data),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tab(String text) {
    final width = MediaQuery.of(context).size.width / 7;
    return Container(
      width: width,
      padding: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Widget> _tabViews(List<List<ProgramObject>> programs) {
    final lists = <Widget>[];
    for (var i = 0; i < programs.length; i++) {
      final list = programs[i];
      lists.add(
        ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
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
                          child: Text(
                            list[index].hhmm(),
                            style: TextStyle(
                              color: Constants.activeColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Text(
                            list[index].title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Constants.activeColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 5, 0, 5),
                          child: Text(
                            list[index].pfm,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Constants.activeColor,
                              fontSize: 12,
                            ),
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
                            _agBloc.addFavorite(list[index]);
                          },
                        );
                      }
                      return Align(
                        child: snapshot.data
                                .where((e) => e.isEqualTo(list[index].title))
                                .isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Constants.activeColor,
                                ),
                                onPressed: () {
                                  _agBloc.deleteFavorite(list[index]);
                                },
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Constants.mainColor,
                                ),
                                onPressed: () {
                                  _agBloc.addFavorite(list[index]);
                                },
                              ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
    return lists;
  }
}
