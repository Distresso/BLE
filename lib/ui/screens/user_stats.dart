import 'package:distressoble/constants/colors.dart';
import 'package:flutter/material.dart';

class UserStatsScreen extends StatefulWidget {
  @override
  _UserStatsScreenState createState() => _UserStatsScreenState();
}

class _UserStatsScreenState extends State<UserStatsScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
              actions: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/distressoLogo.png',
                    fit: BoxFit.fill,
                    height: 20,
                  ),
                ),
                SizedBox(width: 15,)
              ],
              backgroundColor: cardColor,
              title: Text(
                "Heart Rate",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              )),
          body: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Live Heart Rate",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: cardColor,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Daily Stats",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: cardColor,
                    ),
                  ),
                  SizedBox(height: 15,),
                ],
              )),
      ),
    );
  }
}
