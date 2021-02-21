import 'package:ag_viewer/blocs/ag_bloc.dart';
import 'package:ag_viewer/constants.dart';
import 'package:ag_viewer/models/favorite_object.dart';
import 'package:ag_viewer/models/program_object.dart';
import 'package:ag_viewer/pages/favorite_page.dart';
import 'package:ag_viewer/widgets/favorite_item.dart';
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<bool>(
                  builder: (_) => const FavoritePage(),
                ),
              );
            },
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
            return FavoriteItem(list[index]);
          },
        ),
      );
    }
    return lists;
  }
}
