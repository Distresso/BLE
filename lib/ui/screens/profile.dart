
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
          'My Profile',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[IconButton(icon: Icon(Icons.person), onPressed: _logOut), Text('Sign Out')],
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
              return Container(
                child: ListView(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextInput(
                          controller: _nameController,
                          fieldIcon: Icon(Icons.title),
                          hintText: 'First Name',
                        ),
                        TextInput(
                          controller: _surnameController,
                          fieldIcon: Icon(Icons.last_page),
                          hintText: 'Last Name',
                        ),
                        TextInput(controller: _ageController, fieldIcon: Icon(Icons.hourglass_empty), hintText: 'Age'),
                        TextInput(
                          controller: _numberController,
                          fieldIcon: Icon(Icons.phone),
                          hintText: 'Contact Number',
                        ),
                        TextInput(
                          controller: _heightController,
                          fieldIcon: Icon(Icons.vertical_align_top),
                          hintText: 'Height in cm',
                        ),
                        TextInput(
                          controller: _genderController,
                          fieldIcon: Icon(Icons.wc),
                          hintText: 'Gender',
                        ),
                        TextInput(controller: _weightController, fieldIcon: Icon(Icons.confirmation_number), hintText: 'Weight in kg'),
                        FlatButton(onPressed: () => _updateProfile(), child: Text('Update User')),
                      ],
                    )
                  ],
                ),
              );
            }
            return LoadingIndicator();
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
