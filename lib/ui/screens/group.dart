import 'package:distressoble/qubit/location_cubit/location_cubit.dart';
import 'package:distressoble/services/google_maps_service.dart';
import 'package:distressoble/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GroupScreen extends StatefulWidget {
  GroupScreen();
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  GoogleMapController _mapController;
  bool _mapError = false;
  Set<Marker> _markers = {};
  Set<Polyline> _polyLines = {};
  BitmapDescriptor _userIcon;
  BitmapDescriptor _alertIcon;
  LatLng _lastLocation;
  LatLng _dest;
  DateTime _lastUpdated;

  bool get shouldClearMap {
    return false;
  }

  _updateCameraPosition(LatLng position) async {
    if (_mapController != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(position),
      );

      _markers.clear();
      _addUserLocationMarker();
      _setDestinationMarker();
    }
  }

  _updateMap() async {
    if (shouldClearMap) {
      _polyLines = {};
      _markers.clear();
      _updateCameraPosition(_lastLocation);
      _addUserLocationMarker();
      return;
    }

    if (_lastUpdated != null && DateTime.now().difference(_lastUpdated).inSeconds < 5) return;
    _lastUpdated = DateTime.now();

    _markers.clear();

    // if (responseServiceAction != null && responseServiceAction.movementHistory != null && responseServiceAction.movementHistory.length > 0) {
    //   _dest = LatLng(
    //     responseServiceAction.movementHistory.last.lat,
    //     responseServiceAction.movementHistory.last.long,
    //   );
    // } else {
    //   _updateCameraPosition(_lastLocation);
    //   return;
    // }

    _addUserLocationMarker();
    _setDestinationMarker();

    _zoomToBounds();
    _sendRouteRequest();
  }

  _setMapListeners() async {
    // if () {
    _updateMap();
    // }

    // widget?.responseServiceActionStream?.listen((event) {
    //   _responseServiceAction = event;
    //   _updateMap(event);
  }

  _sendRouteRequest() async {
    String route = await GoogleMapsServices().getRouteCoordinates(_lastLocation, _dest);
    if (route == null || route == '') return;

    _polyLines = LocationService().createRoute(route);
    setState(() {});
  }

  setCustomMapPin() async {
    // _alertIcon = await GoogleMapsServices().bitmapDescriptorFromSvgAsset(context, 'assets/svg/alert.svg');
    // _userIcon = await GoogleMapsServices().bitmapDescriptorFromSvgAsset(context, 'assets/svg/bottom_nav.svg');
  }

  _addUserLocationMarker() {
    _markers.add(
      Marker(
        markerId: MarkerId('1'),
        icon: _userIcon,
        position: _lastLocation,
        anchor: Offset(0.5, 0.64),
      ),
    );
    setState(() {});
  }

  _setDestinationMarker() {
    _markers.add(
      Marker(
        markerId: MarkerId('2'),
        position: _dest,
        infoWindow: InfoWindow(title: 'Destination', snippet: "go here"),
        icon: _alertIcon,
      ),
    );
  }

  _onMapCreated(GoogleMapController controller) {
    _addUserLocationMarker();
    _mapController = controller;
    _setMapListeners();
  }

  _zoomToBounds() {
    LatLngBounds bound;
    if (_dest.latitude > _lastLocation.latitude && _dest.longitude > _lastLocation.longitude) {
      bound = LatLngBounds(southwest: _lastLocation, northeast: _dest);
    } else if (_dest.longitude > _lastLocation.longitude) {
      bound = LatLngBounds(southwest: LatLng(_dest.latitude, _lastLocation.longitude), northeast: LatLng(_lastLocation.latitude, _dest.longitude));
    } else if (_dest.latitude > _lastLocation.latitude) {
      bound = LatLngBounds(southwest: LatLng(_lastLocation.latitude, _dest.longitude), northeast: LatLng(_dest.latitude, _lastLocation.longitude));
    } else {
      bound = LatLngBounds(southwest: _dest, northeast: _lastLocation);
    }

    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 100);
    _mapController?.animateCamera(u2)?.then((void v) {
      _check(u2, _mapController);
    });
  }

  _check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    _mapController.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) _check(u, c);
  }

  _map(LatLng position) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          markers: _markers,
          initialCameraPosition: CameraPosition(target: position, zoom: 13),
          onMapCreated: _onMapCreated,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          polylines: _polyLines,
        ),
        Offstage(
          offstage: !_mapError,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Text('Error loading map.\nPlease enable your location in settings', textAlign: TextAlign.center),
                FlatButton(
                  onPressed: () {
                    BlocProvider.of<LocationCubit>(context).locationStarted();
                    setState(() {});
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        // Offstage(
        //   offstage: _responseServiceAction == null && widget.lastResponseServiceAction == null,
        //   child: IconButton(
        //     icon: Icon(Icons.refresh, color: purple),
        //     onPressed: () => _updateMap(_responseServiceAction ?? widget.lastResponseServiceAction),
        //   ),
        // ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    BlocProvider.of<LocationCubit>(context).locationStarted();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LocationCubit, LocationState>(
          listener: (context, state) {
            _mapError = false;

            if (state is LocationLoadedState) {
              _lastLocation = LatLng(state.position.latitude, state.position.longitude);
              _updateMap();
              setState(() {});
            }

            if (state is LocationUpdatedState) {
              _lastLocation = LatLng(state.position.latitude, state.position.longitude);
              _updateMap();
            }

            if (state is LocationPermissionErrorState) {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Error loading map.\nPlease enable your location in settings'), backgroundColor: Colors.red));
              _mapError = true;
              setState(() {});
            }

            if (state is LocationErrorState) {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Error loading map.\nPlease close the app and try again'), backgroundColor: Colors.red));
              _mapError = true;
              setState(() {});
            }
          },
        ),
      ],
      child: _lastLocation != null ? _map(_lastLocation) : GestureDetector(onTap: () => setState(() {})),
    );
  }
}
