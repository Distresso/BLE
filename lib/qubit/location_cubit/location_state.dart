part of 'location_cubit.dart';

class MainLocationState extends Equatable {
  final Position position;

  MainLocationState({this.position});

  @override
  List<Object> get props => [position];

  MainLocationState copyWith({
    Position position,
  }) {
    if ((position == null || identical(position, this.position))) {
      return this;
    }

    return new MainLocationState(
      position: position ?? this.position,
    );
  }
}

abstract class LocationState extends Equatable {
  final MainLocationState mainLocationState;

  LocationState(this.mainLocationState);

  @override
  List<Object> get props => [mainLocationState];
}

class LocationInitial extends LocationState {
  LocationInitial() : super(MainLocationState());
}

class LocationLoadingState extends LocationState {
  LocationLoadingState(MainLocationState mainLocationState) : super(mainLocationState);
}

class LocationLoadedState extends LocationState {
  LocationLoadedState(MainLocationState mainLocationState) : super(mainLocationState);
}

class LocationUpdatedState extends LocationState {
  LocationUpdatedState(MainLocationState mainLocationState) : super(mainLocationState);
}

class LocationPermissionErrorState extends LocationState {
  LocationPermissionErrorState(MainLocationState mainLocationState) : super(mainLocationState);
}

class LocationPermissionGrantedState extends LocationState {
  LocationPermissionGrantedState(MainLocationState mainLocationState) : super(mainLocationState);
}

class LocationErrorState extends LocationState {
  LocationErrorState(MainLocationState mainLocationState) : super(mainLocationState);
}
