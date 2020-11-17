import 'package:flutter/material.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

import '../login/login_screen.dart';

class LoginWithAccountButton extends StatelessWidget {
  final AuthCredentialHelper _authCredentialHelper;

  LoginWithAccountButton({Key key, @required AuthCredentialHelper authCredentialHelper})
      : _authCredentialHelper = authCredentialHelper,
        super(key: key);

  _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (contextLoginScreen) {
        return BlocProvider.value(value: context.bloc<AuthenticationCubit>(), child: LoginScreen(authCredentialHelper: _authCredentialHelper));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Already have an account? log in', style: TextStyle(color: Colors.white),),
      onPressed: () => _navigate(context),
    );
  }
}
