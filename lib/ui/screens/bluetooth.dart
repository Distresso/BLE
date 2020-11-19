// import 'dart:convert';
// import 'package:distressoble/qubit/bluetooth_cubit/bluetooth_cubit.dart';
//import 'package:distressoble/ui/widgets/loading_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class BluetoothScreen extends StatefulWidget {
//   @override
//   _BluetoothScreenState createState() => _BluetoothScreenState();
// }
//
// class _BluetoothScreenState extends State<BluetoothScreen> {
//   Widget build(BuildContext context) => Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth'),
//       ),
//       body: BlocBuilder<BluetoothCubit, BluetoothAppState>(
//         builder: (context, state) {
//           if (state is BluetoothSearching) {
//             return Center(
//               child: Scaffold(body: Center(child: LoadingIndicator())),
//             );
//           }
//           if (state is BluetoothSearched) {
//             List<Container> containers = new List<Container>();
//             for (BluetoothDevice device in state.devices) {
//               containers.add(
//                 Container(
//                   height: 50,
//                   child: Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: Column(
//                           children: <Widget>[
//                             Text('${device.name}'),
//                             Text(device.id.toString()),
//                           ],
//                         ),
//                       ),
//                       FlatButton(
//                         color: Colors.blue,
//                         child: Text(
//                           'Connect',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         onPressed: () async {
//                           BlocProvider.of<BluetoothCubit>(context).connectToDevice(device);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//             return ListView(
//               padding: const EdgeInsets.all(8),
//               children: <Widget>[
//                 ...containers,
//               ],
//             );
//           }
//           if (state is BluetoothConnecting) {
//             return Center(
//               child: Scaffold(body: Center(child: LoadingIndicator())),
//             );
//           }
//           if (state is BluetoothReceiveMessage) {
//             return Center(
//               child: Text('${state.message}'),
//             );
//           }
//           return Center(
//             child: FlatButton(
//               child: Text('${state.message}'),
//               onPressed: () async{
//                   //await state.blunoCharacteristic.write(ascii.encode("bello"));
//                 for(BluetoothCharacteristic c in state.blunoService.characteristics) {
//                   List<int> value = await c.read();
//                   print(ascii.decode(value));
//                 }
//               },
//             ),
//           );
//         },
//       ));
// }
