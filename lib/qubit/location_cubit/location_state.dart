part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  final Position position;

  LocationState({this.position});

  @override
  List<Object> get props => [position];
}

class LocationInitial extends LocationState {}

class LocationLoadingState extends LocationState {}

class LocationLoadedState extends LocationState {
  LocationLoadedState({Position position}) : super(position: position);
}

class LocationUpdatedState extends LocationState {
  LocationUpdatedState({Position position}) : super(position: position);
}

class LocationPermissionErrorState extends LocationState {
  final String error;
  LocationPermissionErrorState(this.error);
  @override
  List<Object> get props => [error];
}

class LocationPermissionGrantedState extends LocationState {}

class LocationErrorState extends LocationState {
  final dynamic error;

  LocationErrorState({@required this.error}) : super(position: null);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'location error { error: $error }';
}
