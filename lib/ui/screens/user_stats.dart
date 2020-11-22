import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:distresso_user_package/distresso_user_package.dart';
import 'package:distressoble/constants/colors.dart';
import 'package:distressoble/qubit/bluetooth_cubit/bluetooth_cubit.dart';
import 'package:distressoble/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:oscilloscope/oscilloscope.dart';

class UserStatsScreen extends StatefulWidget {
  @override
  _UserStatsScreenState createState() => _UserStatsScreenState();
}

class _UserStatsScreenState extends State<UserStatsScreen> {
  List<double> pulses = List();

  @override
  void initState() {
    super.initState();
  }

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
              SizedBox(
                width: 15,
              ),
            ],
            backgroundColor: cardColor,
            title: Text(
              "Heart Rate",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
              ),
            )),
        body: MultiBlocListener(
          listeners: [
            BlocListener<BluetoothCubit, BluetoothAppState>(
              listener: (context, state) {
                if (state is BluetoothReceiveMessage) {
                  pulses.add(double.parse(utf8.decode(state.mainBluetoothAppState.message)));
                }
              },
            ),
          ],
          child: BlocBuilder<BluetoothCubit, BluetoothAppState>(
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
                          child: Oscilloscope(
                            showYAxis: true,
                            yAxisColor: Colors.black,
                            padding: 30,
                            backgroundColor: backgroundColor,
                            traceColor: Colors.red,
                            yAxisMax: 120,
                            yAxisMin: 40,
                            dataSet: pulses,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return LoadingIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
