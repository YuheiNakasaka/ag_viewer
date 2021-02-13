import 'package:ag_viewer/blocs/user_bloc.dart';
import 'package:ag_viewer/constants.dart';
import 'package:ag_viewer/pages/home_page.dart';
import 'package:ag_viewer/pages/program_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  List<Widget> tabs = [];

  @override
  void initState() {
    super.initState();
    final _userBloc = context.read<UserBloc>(userProvider);
    _userBloc.initUser();

    tabs = [const HomePage(), const ProgramPage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 32,
        backgroundColor: Constants.baseColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Constants.mainColor),
            activeIcon: Icon(Icons.home, color: Constants.activeColor),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article, color: Constants.mainColor),
            activeIcon: Icon(Icons.article, color: Constants.activeColor),
            label: '',
          ),
        ],
        onTap: (int index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
