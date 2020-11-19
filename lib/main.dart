
import 'package:distresso_user_package/distresso_user_package.dart';
import 'package:distressoble/distresso.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



void main() {
  runApp(AppEntry());
}

class AppEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
        providers: [BlocProvider<AuthenticationCubit>(create: (context) => AuthenticationCubit()..appStarted())],
        child: Distresso(),
      );
  }
}
