import 'package:distressoble/Model/GroupModel.dart';
import 'package:distressoble/Model/UserModel.dart';
import 'package:distressoble/constants/routes.dart';
import 'package:distressoble/qubit/group_cubit/group_cubit.dart';
import 'package:distressoble/qubit/location_cubit/location_cubit.dart';
import 'package:distressoble/qubit/profile_cubit/profile_cubit.dart';
import 'package:distressoble/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GroupScreen extends StatefulWidget {
  GroupScreen();
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  ProfileCubit _profileCubit;
  GroupCubit _groupCubit;
  Group _group;
  GoogleMapController _mapController;
  bool _mapError = false;
  Set<Marker> _markers = {};
  Set<Polyline> _polyLines = {};
  BitmapDescriptor _userIcon;
  BitmapDescriptor _alertIcon;
  LatLng _lastLocation;
  DateTime _lastUpdated;
  String _dropdownValue;
  List<DropdownMenuItem<String>> _menuItems;
  List<User> _users;



  _getGroupUsers() async{
    await _profileCubit.loadProfile();
    await _groupCubit.loadGroup(user: _profileCubit.state.mainProfileState.user);
    List<String> ids = [_profileCubit.state.mainProfileState.user.uid];
    _group = _groupCubit.state.mainGroupState.group ?? Group(users: ids);
    _users = await _profileCubit.getGroupUsers(_group.users);
    print('');
    await _populateMenuItems();
    setState(() {

    });
  }

  _populateMarkers(){
    try{
      _users.forEach((user) {
        if(user.uid != _profileCubit.state.mainProfileState.user.uid){
          LatLng latlng = LatLng(user.lat, user.lon);
          final Marker marker = Marker(
            markerId: MarkerId(user.uid),
            position: latlng,
            icon: BitmapDescriptor.defaultMarker,
            draggable: false,
            zIndex: 1,
          );
          setState(() {
            _markers.add(marker);
          });
        }
      });

    }catch(error){
      print(error.toString());
    }
  }

  _populateMenuItems()async{
    List<String> names = [];
    await _profileCubit.loadProfile();
    _users != null ?
        _users.forEach((user) => names.add('${user.name} ${user.surname}')):
        names.add('${_profileCubit.state.mainProfileState.user.name} ${_profileCubit.state.mainProfileState.user.surname}');
    _menuItems = names.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(value: value, child: Text(value),)).toList();
    _dropdownValue = names.first;
  }

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
      //_setDestinationMarker();
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


    _addUserLocationMarker();

  }

  _setMapListeners() async {
    _updateMap();
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


  _onMapCreated(GoogleMapController controller) {
    _addUserLocationMarker();
    _mapController = controller;
    _setMapListeners();
  }


  _map(LatLng position) {
    return Scaffold(
      body: Stack(
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
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: _menuItems == null ? 73 : null,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: _menuItems == null ? LoadingIndicator() : Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 8, left: 12, right: 12),
                  child: DropdownButton<String>(
                    value: _dropdownValue,
                    elevation: 16,
                    underline: Container(height: 2, color: Colors.red,),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    items: _menuItems,
                    dropdownColor: Colors.black,
                    isExpanded: true,
                    onChanged: (String value){
                      setState(() {
                        _dropdownValue = value;
                      });
                    },
                  ),
                ),
              ),
              Offstage(
                offstage: _menuItems == null,
                child: Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: RaisedButton(
                      elevation: 16,
                      color: Colors.black,
                      child: Center(child: Text('Manage Group', style: TextStyle(color: Colors.white, fontSize: 14),),),
                      onPressed: () => Navigator.of(context).pushNamed(GROUP_MANAGE),
                    ),
                  ),
                ),
              ),
            ],
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

        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LocationCubit>(context).locationStarted();
    _profileCubit = BlocProvider.of<ProfileCubit>(context);
    _groupCubit = BlocProvider.of<GroupCubit>(context);
    _getGroupUsers();
    _populateMenuItems();
    _populateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LocationCubit, LocationState>(
          listener: (context, state) {
            _mapError = false;

            if (state is LocationLoadedState) {
              _lastLocation = LatLng(state.mainLocationState.position.latitude, state.mainLocationState.position.longitude);
              _updateMap();
              setState(() {});
            }

            if (state is LocationUpdatedState) {
              _lastLocation = LatLng(state.mainLocationState.position.latitude, state.mainLocationState.position.longitude);
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
      child: Scaffold(
        body: _lastLocation != null ? _map(_lastLocation) : GestureDetector(onTap: () => setState(() {})),
      )
    );
  }
}
