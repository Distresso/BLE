import 'dart:convert';
import 'package:distresso_user_package/distresso_user_package.dart';
import 'package:distressoble/constants/colors.dart';
import 'package:distressoble/qubit/bluetooth_cubit/bluetooth_cubit.dart';
import 'package:flare_flutter/flare_actor.dart';
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
            backgroundColor: cardColor,
            title: Text(
              "Heart Rate",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
              ),
            )),
        body: BlocBuilder<BluetoothCubit, BluetoothAppState>(
          builder: (context, state) {
            if (state.mainBluetoothAppState.bluetoothDevice != null) {
              return Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        color: cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Heart Rate",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          color: backgroundColor,
                          child: Row(
                            children: [
                              Expanded(
                                child: FlareActor(
                                  'assets/navbarIcons/DistressoProjectLoading.flr',
                                  isPaused: false,
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                  animation: 'go',
                                ),
                              ),
                              Text('${Utf8Decoder().convert(state.mainBluetoothAppState.message)}'),
                            ],
                          )),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: FlareActor(
                      'assets/navbarIcons/DistressoProjectLoading.flr',
                      isPaused: false,
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: 'go',
                    ),
                  ),
                  Text(
                    'Please Connect to a bluetooth device',
                    style: TextStyle(color: Colors.white, fontFamily: 'monstercat', fontSize: 20),
                  ),
                  Spacer(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
