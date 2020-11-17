import 'package:distressoble/ui/screens/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:sp_user_repository/sp_user_repository.dart';


class CreateAccountButton extends StatelessWidget {
  final AuthCredentialHelper _authCredentialHelper;

  CreateAccountButton({Key key, @required AuthCredentialHelper authCredentialHelper})
      : _authCredentialHelper = authCredentialHelper,
        super(key: key);

  _navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (contextLoginScreen) {
        return BlocProvider.value(value: context.bloc<AuthenticationCubit>(), child: RegisterScreen(authCredentialHelper: _authCredentialHelper));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Create an Account'),
      onPressed: () => _navigate(context),
    );
  }
}
