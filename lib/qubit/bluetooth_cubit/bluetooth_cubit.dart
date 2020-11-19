import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'bluetooth_state.dart';

class BluetoothCubit extends Cubit<BluetoothAppState> {
  BluetoothCubit() : super(BluetoothInitial());

  void connectToDevice(BluetoothDevice bluetoothDevice) async {
    if (bluetoothDevice != null) {
      if (!state.mainBluetoothAppState.isConnected) {
        await BluetoothConnection.toAddress(bluetoothDevice.address).then((_connection) {
          emit(BluetoothConnected(state.mainBluetoothAppState.copyWith(bluetoothConnection: _connection)));
          state.mainBluetoothAppState.bluetoothConnection.input.listen((data) {
            emit(BluetoothReceiveMessage(state.mainBluetoothAppState.copyWith(message: data.toString()))); //TODO properly convert to string
            print(data);
          }).onDone(() {
            emit(BluetoothInitial());
          });
        }).catchError((error) {
          emit(BluetoothError(state.mainBluetoothAppState));
        });
      }
    }
  }

  Future<List<BluetoothDevice>> getPairedDevices(BluetoothDevice bl) async {
    FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
    try {
      return _bluetooth.getBondedDevices();
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  void disconnect() async {
    await state.mainBluetoothAppState.bluetoothConnection.close();
    if (!state.mainBluetoothAppState.isConnected) {
      emit(BluetoothInitial());
    }
  }
}
