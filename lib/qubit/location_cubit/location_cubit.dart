import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  StreamSubscription locationSubscription;

  LocationCubit() : super(LocationInitial());

  askLocationPermission() async {
    bool granted = true;

    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse,
    ].request();

    if (statuses[Permission.location] != PermissionStatus.granted) {
      granted = false;
      emit(LocationPermissionErrorState('Permission error ${statuses[Permission.location].toString().split('.').last}'));
    }

    if (statuses[Permission.locationAlways] != PermissionStatus.granted) {
      granted = false;
      emit(LocationPermissionErrorState('Permission error ${statuses[Permission.locationAlways].toString().split('.').last}'));
    }

    if (statuses[Permission.locationWhenInUse] != PermissionStatus.granted) {
      granted = false;
      emit(LocationPermissionErrorState('Permission error ${statuses[Permission.locationWhenInUse].toString().split('.').last}'));
    }

    if (granted) {
      locationStarted();
    }
  }

  locationStarted() async {
    emit(LocationLoadingState());

    LocationPermission status = await checkPermission();
    bool enabled = await isLocationServiceEnabled();

    if ((status == LocationPermission.always || status == LocationPermission.whileInUse) && enabled) {
      Position position = await getLastKnownPosition();
      if (position != null) emit(LocationLoadedState(position: position));
      locationSubscription?.cancel();
      locationSubscription = getPositionStream().listen(
        (Position position) => locationChanged(position: position),
      );
    } else if (status == LocationPermission.denied || status == LocationPermission.deniedForever) {
      askLocationPermission();
    } else if (!enabled) {
      emit(LocationErrorState(error: 'Location disabled on the device'));
    } else {
      emit(LocationPermissionErrorState('Location permission error ${status.toString().split('.').last}'));
    }
  }

  stopLocation() async {
    locationSubscription?.cancel();
    emit(LocationInitial());
  }

  locationChanged({Position position}) async {
    emit(LocationUpdatedState(position: position));
  }

  @override
  Future<void> close() {
    locationSubscription?.cancel();
    return super.close();
  }
}
