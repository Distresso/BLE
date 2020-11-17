 part of 'bluetooth_cubit.dart';

 @immutable
 abstract class BluetoothAppState extends Equatable {
   final String message;

   BluetoothAppState({this.message});

   @override
   List<Object> get props => [message];
 }

 class BluetoothInitial extends BluetoothAppState {
   BluetoothInitial() : super(message: "none");
 }

 class BluetoothSearching extends BluetoothAppState {
   BluetoothSearching({String message}) : super(message: "searching");
 }

 class BluetoothSearched extends BluetoothAppState {
   final String message;

   BluetoothSearched({this.message}) : super(message: message);
 }

 class BluetoothConnecting extends BluetoothAppState {
   final String message;
   BluetoothConnecting({this.message}) : super(message: message);
 }

 class BluetoothConnected extends BluetoothAppState {
   final String message;
   BluetoothConnected({this.message}) : super(message: message);
 }

 class BluetoothError extends BluetoothAppState {
   BluetoothError({String message}) : super(message: message);
 }

 class BluetoothReceiveMessage extends BluetoothAppState {
   BluetoothReceiveMessage({String message}) : super(message: message);
 }
