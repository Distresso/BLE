 import 'dart:convert';

 import 'package:bloc/bloc.dart';
 import 'package:equatable/equatable.dart';
 import 'package:flutter/material.dart';

 part 'bluetooth_state.dart';

 class BluetoothCubit extends Cubit<BluetoothAppState> {
   BluetoothCubit() : super(BluetoothInitial());

   void getAvailableDevices() async {
   }

   void connectToDevice() async {
   }

   void setNotification() async {
   }

   void setService() async {
   }

   void setCharacteristic() {
   }
 }