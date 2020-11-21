import 'package:distresso_user_package/distresso_user_package.dart';
import 'package:distressoble/constants/colors.dart';
import 'package:distressoble/ui/screens/login/create_account_button.dart';
import 'package:flutter/material.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  final AuthCredentialHelper _authCredentialHelper;

  LoginScreen({Key key, @required AuthCredentialHelper authCredentialHelper})
      : _authCredentialHelper = authCredentialHelper,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<RegisterCubit>(create: (context) => RegisterCubit(authCredentialHelper: _authCredentialHelper)),
          BlocProvider<LoginCubit>(create: (context) => LoginCubit(authCredentialHelper: _authCredentialHelper)),
        ],
        child: LoginForm(authCredentialHelper: _authCredentialHelper),
      ),
    );
  }
}
