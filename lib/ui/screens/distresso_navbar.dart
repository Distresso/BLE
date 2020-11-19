import 'package:distressoble/constants/colors.dart';
import 'package:distressoble/ui/screens/home.dart';
import 'package:distressoble/ui/screens/maps_test.dart';
import 'package:distressoble/ui/screens/profile.dart';
import 'package:distressoble/ui/screens/splash_screen.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
class MenuItem {
  final String name;
  final Color color;
  final double x;

  MenuItem({this.name, this.color, this.x});
}
class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  MenuItem active = MenuItem();
  int selectedIndex = 0;
  List items = [
    MenuItem(x: -1.0, name: 'DistressoNavbarHR', color: hrColour),
    MenuItem(x: -0.3, name: 'DistressoNavbarUser', color: userColour),
    MenuItem(x: 0.3, name: 'DistressoNavbarUsers', color: groupColour),
    MenuItem(x: 1.0, name: 'DistressoNavbarBluetooth', color: bluetoothColour),
  ];
  List screens =[
    HomeScreen(), //user stats
    ProfileScreen(),
    MapScreen(),
    HomeScreen(), // Bluetooth Screen
  ];

  Widget _flare(MenuItem item) {
    return GestureDetector(
        child: AspectRatio(
          aspectRatio: 1,
          child: Padding(
            padding: EdgeInsets.only(top: 5),
            child: FlareActor(
              'assets/navbarIcons/${item.name}.flr',
              isPaused: item.name == active.name ? false :  true,
              color: item.color,
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: item.name == active.name ? 'idle' : 'go' ,
            ),
          ),
        ),
        onTap: () {
          setState(() {
            selectedIndex = items.indexWhere((element) => element == item);
            active = item;
          });
        });
  }

  @override
  void initState() {
    super.initState();
    active = items[0];
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(flex: 8, child: screens[selectedIndex],),
        Expanded(
          flex: 1,
          child: Container(
            color: cardColor,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: Duration(microseconds: 2000),
                  alignment: Alignment(active.x, -1),
                  child: AnimatedContainer(
                    duration: Duration(microseconds: 1000),
                    height: 6,
                    width: w * 0.25,
                    color: active.color,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: items.map((item) {
                      return _flare(item);
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}