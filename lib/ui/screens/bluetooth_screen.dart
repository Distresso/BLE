import 'package:distressoble/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothTempScreen extends StatefulWidget {
  @override
  _BluetoothTempScreenState createState() => _BluetoothTempScreenState();
}

class _BluetoothTempScreenState extends State<BluetoothTempScreen> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
            backgroundColor: cardColor,
            title: Center(
              child: Text(
                "Pair Bluetooth",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: Container(
                      height: 60,
                      decoration: BoxDecoration(color: cardColor),
                      child: Padding(
                        padding: EdgeInsets.only(top: 14, bottom: 17, left: 20),
                        child: Text(
                          "Bluetooth",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 26, color: Colors.grey),
                        ),
                      )),
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(color: cardColor),
                  child: Switch(
                    inactiveTrackColor: Colors.red,
                    value: _bluetoothState.isEnabled,
                    onChanged: (value) async{
                      if (value) {
                        await FlutterBluetoothSerial.instance.requestEnable();
                      } else {
                        await FlutterBluetoothSerial.instance.requestDisable();
                      }
                      setState(() {
                        FlutterBluetoothSerial.instance.state.then((state) {
                          _bluetoothState = state;
                        });
                      });
                    },
                    activeTrackColor: bluetoothColour,
                    activeColor: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
