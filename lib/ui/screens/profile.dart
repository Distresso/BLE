import 'package:distresso_user_package/distresso_user_package.dart';
import 'package:distressoble/constants/colors.dart';
import 'package:distressoble/qubit/profile_cubit/profile_cubit.dart';
import 'package:distressoble/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/screenutil.dart';

import '../../Model/UserModel.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileCubit _profileCubit;
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _numberController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _genderController = TextEditingController();

  _updateProfile() {
    _profileCubit.updateProfile(
      _profileCubit.state.mainProfileState.user.copyWith(
        name: _nameController.text,
        surname: _surnameController.text,
        phoneNumber: _numberController.text,
        age: num.parse(_ageController.text),
        height: num.parse(_heightController.text),
        weight: num.parse(_weightController.text),
        gender: _genderController.text,
      ),
    );
  }

  _logOut() {
    BlocProvider.of<AuthenticationCubit>(context).loggedOut();
  }

  _loadInitialValues(ProfileLoaded state) {
    try {
      _nameController.text = state.mainProfileState.user.name;
      _surnameController.text = state.mainProfileState.user.surname;
      _numberController.text = state.mainProfileState.user.phoneNumber;
      _ageController.text = state.mainProfileState.user.age.toString();
      _heightController.text = state.mainProfileState.user.height.toString();
      _weightController.text = state.mainProfileState.user.weight.toString();
      _genderController.text = state.mainProfileState.user.gender;
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _profileCubit = BlocProvider.of<ProfileCubit>(context);
    _profileCubit.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: cardColor,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: _logOut,
            child: Row(
              children: [
                Icon(Icons.person),
                Center(child: Text('Sign Out')),
              ],
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _loadInitialValues(state);
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileUpdating) {
              return Center(
                child: Column(
                  children: [
                    LoadingIndicator(),
                    Text(state.mainProfileState.message),
                  ],
                ),
              );
            } else if (state is ProfileLoaded) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Theme(
                            data: ThemeData(primarySwatch: swatchWhite),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                contentPadding: const EdgeInsets.all(20.0),
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Theme(
                            data: ThemeData(primarySwatch: swatchWhite),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: _surnameController,
                              decoration: InputDecoration(
                                labelText: 'Surname',
                                contentPadding: const EdgeInsets.all(20.0),
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Theme(
                            data: ThemeData(primarySwatch: swatchWhite),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: _ageController,
                              decoration: InputDecoration(
                                labelText: 'Age',
                                contentPadding: const EdgeInsets.all(20.0),
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Theme(
                            data: ThemeData(primarySwatch: swatchWhite),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: _numberController,
                              decoration: InputDecoration(
                                labelText: 'Number',
                                contentPadding: const EdgeInsets.all(20.0),
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Theme(
                            data: ThemeData(primarySwatch: swatchWhite),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: _heightController,
                              decoration: InputDecoration(
                                labelText: 'Height',
                                contentPadding: const EdgeInsets.all(20.0),
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Theme(
                            data: ThemeData(primarySwatch: swatchWhite),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: _genderController,
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                contentPadding: const EdgeInsets.all(20.0),
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Theme(
                            data: ThemeData(primarySwatch: swatchWhite),
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: _weightController,
                              decoration: InputDecoration(
                                labelText: 'Weight',
                                contentPadding: const EdgeInsets.all(20.0),
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: RaisedButton(
                                    onPressed: () => _updateProfile(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        'Update User',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    color: secondaryButtonColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(child: LoadingIndicator());
          },
        ),
      ),
    );
  }
}

class TextInput extends StatefulWidget {
  TextInput({@required this.fieldIcon, this.hintText, this.controller});

  final Icon fieldIcon;
  final String hintText;
  final TextEditingController controller;

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(keyboardType: TextInputType.visiblePassword, controller: widget.controller, style: TextStyle(color: Colors.white), decoration: InputDecoration(icon: widget.fieldIcon, hintText: widget.hintText, hintStyle: TextStyle(color: Colors.grey)));
  }
}
