import 'package:distresso_user_package/distresso_user_package.dart';
import 'package:distressoble/qubit/group_cubit/group_cubit.dart';
import 'package:distressoble/qubit/location_cubit/location_cubit.dart';
import 'package:distressoble/qubit/profile_cubit/profile_cubit.dart';
import 'package:distressoble/store/firebase_user_repository.dart';
import 'package:distressoble/ui/screens/distresso_navbar.dart';
import 'package:distressoble/ui/screens/group_management.dart';
import 'package:distressoble/ui/screens/login/login_screen.dart';
import 'package:distressoble/ui/screens/maps_test.dart';
import 'package:distressoble/ui/screens/splash_screen.dart';
import 'package:distressoble/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

import 'constants/routes.dart';
import 'ui/screens/profile.dart';

class Distresso extends StatelessWidget {
  static AuthCredentialHelper _authCredentialHelper;
  static AppUserProfileRepository _appUserProfileRepository = AppUserProfileRepository();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            BlocProvider.of<AuthenticationCubit>(context)..appStarted();
          }
        },
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            _authCredentialHelper = state.authCredentialHelper;

            if (state is Uninitialized) {
              return SplashScreen();
            }

            if (state is Unauthenticated) {
              return LoginScreen(authCredentialHelper: _authCredentialHelper);
            }

            if (state is Authenticated) {
              return MultiBlocProvider(
                providers: [
                  //BlocProvider<BluetoothCubit>(create: (context) => BluetoothCubit()),
                  BlocProvider<LocationCubit>(
                    create: (context) => LocationCubit(),
                  ),
                  BlocProvider<ProfileCubit>(create: (context) => ProfileCubit(user: _appUserProfileRepository)),
                  BlocProvider<GroupCubit>(create: (context) => GroupCubit(),)
                ],
                child: MaterialApp(
                  theme: ThemeData(primaryColor: Colors.red),
                  debugShowCheckedModeBanner: false,
                  routes: {
                    PROFILE: (context) => ProfileScreen(),
                    HOME: (context) => Navbar(),
                    GROUP: (context) => MapScreen(),
                    GROUP_MANAGE: (context) => GroupManagementScreen(),
                  },
                ),
              );
            }

            return Scaffold(body: Center(child: LoadingIndicator()));
          },
        ),
      ),
    );
  }
}
