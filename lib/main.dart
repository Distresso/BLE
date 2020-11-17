import 'dart:io';

import 'package:distressoble/distresso.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_user_repository/sp_user_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  // if(Platform.isIOS) GoogleMap.init('AIzaSyDUO1mykE748jzIuHstIIO77FDIYqibuuY');
  // if(Platform.isAndroid) GoogleMap.init('AIzaSyDUHDqgK81i8sifWczWOmTk0OvWGxIlNRQ');
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
