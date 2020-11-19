import 'package:distressoble/constants/colors.dart';
import 'package:distressoble/ui/screens/login/create_account_button.dart';
import 'package:distressoble/ui/screens/login/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sp_user_repository/sp_user_repository.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatefulWidget {
  final AuthCredentialHelper _authCredentialHelper;

  LoginForm({Key key, @required AuthCredentialHelper authCredentialHelper})
      : _authCredentialHelper = authCredentialHelper,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginCubit _loginCubit;
  AuthenticationCubit _authenticationCubit;

  AuthCredentialHelper get _authCredentialHelper =>
      widget._authCredentialHelper;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.status.isValid &&
        isPopulated &&
        !state.status.isSubmissionInProgress;
  }

  @override
  void initState() {
    super.initState();
    _loginCubit = BlocProvider.of<LoginCubit>(context);
    _authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text('Login Failure\n${state.message}'),
                backgroundColor: Colors.red));
        }

        if (state.status.isSubmissionInProgress) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }

        if (state.status.isSubmissionSuccess) {
          _authenticationCubit.loggedIn();
          Navigator.popUntil(
              context, ModalRoute.withName(Navigator.defaultRouteName));
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                  ),
                  Center(
                      child: Image.asset(
                        'assets/images/distressoLogo.png',
                        height: 120,
                        width: 120,
                        fit: BoxFit.fill,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Distresso",
                      style: TextStyle(
                        fontFamily: "Montserrat-SemiBold",
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white),
                            contentPadding: const EdgeInsets.all(20.0),
                            errorText:
                            state.email.invalid ? 'invalid email' : null,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) =>
                              _loginCubit.emailChanged(value),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white),
                            errorText: state.password.invalid
                                ? 'invalid password'
                                : null,
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          onChanged: (value) =>
                              _loginCubit.passwordChanged(value),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LoginButton(
                            onPressed: isLoginButtonEnabled(state)
                                ? _onFormSubmitted
                                : null),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
  void _onFormSubmitted() {
    _loginCubit.loginWithEmailPasswordPressed(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
}
