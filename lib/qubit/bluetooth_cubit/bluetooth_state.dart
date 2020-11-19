part of 'bluetooth_cubit.dart';

class MainBluetoothAppState extends Equatable {
  final String message;
  final BluetoothConnection bluetoothConnection;
  final BluetoothDevice bluetoothDevice;

  MainBluetoothAppState({this.bluetoothConnection, this.message, this.bluetoothDevice});

  @override
  List<Object> get props => [message];

  MainBluetoothAppState copyWith({
    String message,
    BluetoothConnection bluetoothConnection,
    BluetoothDevice bluetoothDevice,
  }) {
    if ((message == null || identical(message, this.message)) && (bluetoothConnection == null || identical(bluetoothConnection, this.bluetoothConnection)) && (bluetoothDevice == null || identical(bluetoothDevice, this.bluetoothDevice))) {
      return this;
    }

    return new MainBluetoothAppState(
      message: message ?? this.message,
      bluetoothConnection: bluetoothConnection ?? this.bluetoothConnection,
      bluetoothDevice: bluetoothDevice ?? this.bluetoothDevice,
    );
  }

  bool get isConnected => bluetoothConnection != null && bluetoothConnection.isConnected;
}

@immutable
abstract class BluetoothAppState extends Equatable {
  final MainBluetoothAppState mainBluetoothAppState;

  BluetoothAppState(this.mainBluetoothAppState);

  @override
  List<Object> get props => [mainBluetoothAppState];
}

class BluetoothInitial extends BluetoothAppState {
  BluetoothInitial() : super(MainBluetoothAppState());
}

class BluetoothSearching extends BluetoothAppState {
  BluetoothSearching(MainBluetoothAppState mainBluetoothAppState) : super(mainBluetoothAppState);
}

class BluetoothSearched extends BluetoothAppState {
  BluetoothSearched(MainBluetoothAppState mainBluetoothAppState) : super(mainBluetoothAppState);
}

class BluetoothConnecting extends BluetoothAppState {
  BluetoothConnecting(MainBluetoothAppState mainBluetoothAppState) : super(mainBluetoothAppState);
}

class BluetoothConnected extends BluetoothAppState {
  BluetoothConnected(MainBluetoothAppState mainBluetoothAppState) : super(mainBluetoothAppState);
}

class BluetoothError extends BluetoothAppState {
  BluetoothError(MainBluetoothAppState mainBluetoothAppState) : super(mainBluetoothAppState);
}

class BluetoothReceiveMessage extends BluetoothAppState {
  BluetoothReceiveMessage(MainBluetoothAppState mainBluetoothAppState) : super(mainBluetoothAppState);
}
