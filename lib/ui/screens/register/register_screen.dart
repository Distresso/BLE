import 'package:distresso_user_package/distresso_user_package.dart';
import 'package:distressoble/constants/colors.dart';
import 'package:flutter/material.dart';

import 'register_form.dart';

class RegisterScreen extends StatelessWidget {
  final AuthCredentialHelper _authCredentialHelper;

  RegisterScreen({Key key, @required AuthCredentialHelper authCredentialHelper})
      : _authCredentialHelper = authCredentialHelper,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          top: false,

          child: Center(
            child: BlocProvider<RegisterCubit>(
              create: (context) => RegisterCubit(authCredentialHelper: _authCredentialHelper),
              child: RegisterForm(authCredentialHelper: _authCredentialHelper),
            ),
          ),
        ),
    );
  }
}
