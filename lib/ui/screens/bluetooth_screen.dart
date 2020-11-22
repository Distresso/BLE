import 'package:distressoble/constants/colors.dart';
import 'package:distressoble/constants/routes.dart';
import 'package:distressoble/qubit/bluetooth_cubit/bluetooth_cubit.dart';
import 'package:distressoble/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Bluetooth",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: 60,
              padding: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(color: cardColor),
              child: Switch(
                inactiveTrackColor: Colors.red,
                value: _bluetoothState.isEnabled,
                onChanged: (value) async {
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
            ),
          ],
        ),
      ),
      body: BlocBuilder<BluetoothCubit, BluetoothAppState>(
        builder: (context, state) {
          return ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      color: cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Device",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  state.mainBluetoothAppState.bluetoothDevice == null
                      ? CustomButton(
                          onTap: () async {
                            var bluetoothDevice = await Navigator.of(context).pushNamed(SELECT_DEVICE);
                            if (bluetoothDevice != null) {
                              BlocProvider.of<BluetoothCubit>(context).connectToDevice(bluetoothDevice);
                            }
                          },
                          text: 'Connect To A Device',
                        )
                      : Card(
                          color: cardColor,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Name",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "${state.mainBluetoothAppState.bluetoothDevice.name}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Address",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "${state.mainBluetoothAppState.bluetoothDevice.address}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      color: cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomButton(
                    onTap: () => FlutterBluetoothSerial.instance.openSettings(),
                    text: 'Bluetooth Settings',
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
