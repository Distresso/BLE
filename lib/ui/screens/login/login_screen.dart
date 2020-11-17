import 'package:distressoble/constants/colors.dart';
import 'package:distressoble/ui/screens/login/create_account_button.dart';
import 'package:flutter/material.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  final AuthCredentialHelper _authCredentialHelper;

  LoginScreen({Key key, @required AuthCredentialHelper authCredentialHelper})
      : _authCredentialHelper = authCredentialHelper,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<RegisterCubit>(create: (context) => RegisterCubit(authCredentialHelper: _authCredentialHelper)),
            BlocProvider<LoginCubit>(create: (context) => LoginCubit(authCredentialHelper: _authCredentialHelper)),
          ],
          child: Container(color: backgroundColor, child: LoginForm(authCredentialHelper: _authCredentialHelper)),
        ),
        bottomNavigationBar:  Row(
          children: [
            Expanded(
              child: Container(
                height: 60,
                child: RaisedButton(
                  onPressed: () {},
                  color: secondaryButtonColor,
                  child: Text(
                    "Sign in with Google",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 60,
                color: primaryButtonColor,
                child:  CreateAccountButton(
                    authCredentialHelper: _authCredentialHelper),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
