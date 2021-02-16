import 'package:ag_viewer/blocs/ag_bloc.dart';
import 'package:ag_viewer/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgramPage extends StatefulWidget {
  const ProgramPage();
  @override
  _ProgramPageState createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  AgBloc _agBloc;

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
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 60,
            child: Text(
              'hogehoge',
              style: TextStyle(
                color: Constants.activeColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
