import 'package:flutter/material.dart';
class MainContainer extends StatefulWidget {
  @override
  _MainContainerState createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;
  _selectPageAtIndex(int selectedIndex) {
    setState(() {
      _selectedIndex = selectedIndex;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
