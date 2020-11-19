import 'package:distressoble/constants/colors.dart';
import 'package:distressoble/ui/screens/register/login_with_account_button.dart';
import 'package:flutter/material.dart';
import 'package:sp_user_repository/sp_user_repository.dart';
import 'package:formz/formz.dart';
import 'register_button.dart';

class RegisterForm extends StatefulWidget {
  final AuthCredentialHelper _authCredentialHelper;

  RegisterForm({Key key, @required AuthCredentialHelper authCredentialHelper})
      : _authCredentialHelper = authCredentialHelper,
        super(key: key);

  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterCubit _registerCubit;

  AuthCredentialHelper get _authCredentialHelper =>
      widget._authCredentialHelper;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.status.isValid &&
        isPopulated &&
        !state.status.isSubmissionInProgress;
  }

  @override
  void initState() {
    super.initState();
    _registerCubit = BlocProvider.of<RegisterCubit>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Text('Registering...'),
                  CircularProgressIndicator()
                ])));
        }

        if (state.status.isSubmissionSuccess) {
          BlocProvider.of<AuthenticationCubit>(context).loggedIn();
          Navigator.of(context).pop();
        }

        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child:
                              Text('Registration Failure\n${state.message}')),
                      Icon(Icons.error)
                    ]),
                backgroundColor: Colors.red));
          print('Register Failure');
        }
      },
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: backgroundColor,
              body: ListView(
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
                          children: <Widget>[
                            Column(
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (_) {
                                    return state.email.invalid
                                        ? 'Invalid Email'
                                        : null;
                                  },
                                ),
                                Divider(endIndent: 20),
                                TextFormField(
                                  controller: _passwordController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (_) {
                                    return state.email.invalid
                                        ? 'Invalid Email'
                                        : null;
                                  },
                                  obscureText: true,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: LoginWithAccountButton(
                                  authCredentialHelper: _authCredentialHelper),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              bottomNavigationBar: Row(children: [
                Expanded(
                    child: Container(
                        height: 60,
                        child: FlatButton(
                            onPressed: isRegisterButtonEnabled(state) ? _onFormSubmitted : null,
                            color: primaryButtonColor,
                            child: Text(
                              "Register",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ))))
              ]));
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerCubit.registerEmailChanged(_emailController.text);
  }

  void _onPasswordChanged() {
    _registerCubit.registerPasswordChanged(_passwordController.text);
  }

  void _onFormSubmitted() {
    _registerCubit.registerSubmitted(
      _emailController.text,
      _passwordController.text,
    );
  }
}
