import 'package:distressoble/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SelectBluetoothDevice extends StatefulWidget {
  @override
  _SelectBluetoothDeviceState createState() => _SelectBluetoothDeviceState();
}

class _SelectBluetoothDeviceState extends State<SelectBluetoothDevice> {
  List<BluetoothDevice> _devicesList = List<BluetoothDevice>();
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;

  getPairedDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await _bluetooth.getBondedDevices();
    } catch (error) {
      print(error.toString());
    }

    setState(() {
      _devicesList = devices;
    });
  }

  @override
  void initState() {
    super.initState();
    getPairedDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cardColor,
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Devices",
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
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => getPairedDevices(),
              ),
            ),
          ],
        ),
      ),
      body: _devicesList?.length == 0
          ? Center(child: Text('Please make sure that you have paired with the wristband before'))
          : Container(
              color: backgroundColor,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _devicesList.length,
                    itemBuilder: (context, index) {
                      BluetoothDevice thisBluetoothDevice = _devicesList[index];
                      return GestureDetector(
                        onTap: () => Navigator.pop(context, thisBluetoothDevice),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
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
                                            "${thisBluetoothDevice.name}",
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
                                            "${thisBluetoothDevice.address}",
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
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
