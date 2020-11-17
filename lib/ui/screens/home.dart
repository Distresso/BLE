
import 'dart:io';

import 'package:distressoble/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [IconButton(icon: Icon(Icons.account_box), onPressed: () => Navigator.pushNamed(context, PROFILE))],
      ),
      body: Column(
        children: [
          Center(
            child: FlatButton(
              child: Text(
                'Bluetooth Screen',
              ),
              onPressed: () => Navigator.pushNamed(context, BLE),
            ),
          ),
          Center(
            child: FlatButton(
              child: Text(
                'Map Screen',
              ),
              onPressed: () async{
                if(Platform.isIOS) {
                  print(await Permission.locationWhenInUse.status);
                  print(await Permission.locationWhenInUse.serviceStatus.isEnabled);
                  if (await Permission.locationWhenInUse.isGranted == false) {
                    print('eee');
                    await Permission.locationWhenInUse
                        .request()
                        .isGranted;
                    setState(() {
                      print('aaa');
                    });
                  }
                }
                Navigator.of(context).pushNamed(GROUP);
              }
            ),
          ),
        ],
      ),
    );
  }
}
