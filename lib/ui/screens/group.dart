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
  User _selectedUser;
  bool _showDetails = false;



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

  _populateMarkers()async{
    try{
      await _getGroupUsers();
      _users.forEach((user) {
          LatLng latlng = LatLng(user.lat, user.lon);
          final Marker marker = Marker(
            markerId: MarkerId(user.uid),
            position: latlng,
            icon: BitmapDescriptor.defaultMarker,
            draggable: false,
            onTap: (){
              setState(() {
                _selectedUser = user;
                _showDetails = !_showDetails;
              });
            },
            zIndex: 1,
          );
          setState(() {
            _markers.add(marker);
          });
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


      await _addUserLocationMarker();
      //_setDestinationMarker();
    }
  }

  _updateMap() async {
    if (shouldClearMap) {
      _polyLines = {};
      _markers.clear();
      await _populateMarkers();
      _updateCameraPosition(_lastLocation);
      await _profileCubit.updateProfile(_profileCubit.state.mainProfileState.user.copyWith(lat: _lastLocation.latitude, lon: _lastLocation.longitude, lastUpdated: _lastUpdated));
     await _addUserLocationMarker();
      return;
    }

    if (_lastUpdated != null && DateTime.now().difference(_lastUpdated).inSeconds < 5) return;
    _lastUpdated = DateTime.now();
    await _profileCubit.updateProfile(_profileCubit.state.mainProfileState.user.copyWith(lat: _lastLocation.latitude, lon: _lastLocation.longitude, lastUpdated: _lastUpdated));
    _markers.clear();


   await _addUserLocationMarker();

  }

  _setMapListeners() async {
    await _updateMap();
  }



  _addUserLocationMarker()async {
    await _populateMarkers();
//    _markers.add(
//      Marker(
//        markerId: MarkerId('1'),
//        icon: _userIcon,
      //  position: _lastLocation,
//        anchor: Offset(0.5, 0.64),
//      ),
//    );
    setState(() {});
  }


  _onMapCreated(GoogleMapController controller) async{
    await _populateMarkers();
    _mapController = controller;
   await _setMapListeners();
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
            children: [
              Spacer(),
              Offstage(
                offstage: !_showDetails,
                child: _detailSheet(_selectedUser),
              ),
            ],
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
                      User user = _users.firstWhere((user) => '${user.name} ${user.surname}' == value);
                      setState(() async {
                        _dropdownValue = value;
                        await _updateCameraPosition(LatLng(user.lat, user.lon));
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

  _detailSheet(User user){
    return Container(
      alignment: Alignment.bottomLeft,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(child: Text('${user?.name ?? 'Name'} ${user?.surname ?? 'Surname'}', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),)),
            Expanded(child: Row(
              children: [
                Expanded(flex: 2,child: Text('Heartrate: ${user?.currVital != null  && user?.currVital != 0? '${user.currVital.toString()} BPM' : 'N/A'}', style: TextStyle(color: Colors.white, fontSize: 12)),),
                Expanded(flex: 3,child: Text('Last Updated: ${user?.lastUpdated != null ? user.lastUpdated.toString() : 'N/A'}', style: TextStyle(color: Colors.white, fontSize: 12)),)
              ],
            ))
          ],
        ),
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
