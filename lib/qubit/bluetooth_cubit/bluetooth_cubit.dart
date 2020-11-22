import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'bluetooth_state.dart';

class BluetoothCubit extends Cubit<BluetoothAppState> {
  BluetoothCubit() : super(BluetoothInitial());

  connectToDevice(BluetoothDevice bluetoothDevice) async {
    if (bluetoothDevice != null && !state.mainBluetoothAppState.isConnected) {
      emit(BluetoothConnecting(state.mainBluetoothAppState));
      await BluetoothConnection.toAddress(bluetoothDevice.address).then((_connection) {
        emit(BluetoothConnected(state.mainBluetoothAppState.copyWith(bluetoothConnection: _connection, bluetoothDevice: bluetoothDevice)));
        state.mainBluetoothAppState.bluetoothConnection.input.listen((data) {
          emit(BluetoothReceiveMessage(state.mainBluetoothAppState.copyWith(message: data))); //TODO properly convert to string
          print(data);
        }).onDone(() {
          emit(BluetoothInitial());
        });
      }).catchError((error) {
        emit(BluetoothError(state.mainBluetoothAppState));
      });
    }
  }

  Future<List<BluetoothDevice>> getPairedDevices() async {
    FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
    try {
      return _bluetooth.getBondedDevices();
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  disconnect() async {
    if (!state.mainBluetoothAppState.isConnected) {
      await state.mainBluetoothAppState.bluetoothConnection.close();
      emit(BluetoothInitial());
    }
  }
}
