import 'package:bloc/bloc.dart';
import 'package:distresso_user_package/distresso_user_package.dart';
import 'package:distressoble/Model/UserModel.dart';
import 'package:distressoble/store/firebase_user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AppUserProfileRepository _user;
  ProfileCubit({@required AppUserProfileRepository user})
      : _user = user,
        super(ProfileInitial());

  loadProfile() async {
    emit(ProfileLoading(state.mainProfileState.copyWith(message: 'Loading...')));
    try {
      User user = await _user.getUserProfile();
      AuthProviderUserDetails authProviderUserDetails = await AuthProviderRepository().loadUserFromPrefs();
      emit(ProfileLoaded(state.mainProfileState.copyWith(user: user, authProviderUserDetails: authProviderUserDetails)));
    } catch (error) {
      emit(ProfileError(state.mainProfileState.copyWith(message: error.toString())));
    }
  }

  updateProfile(User user) async {
    emit(ProfileLoading(state.mainProfileState.copyWith(message: 'Loading...')));
    try {
      await _user.updateUserProfile(userProfile: user, authProviderUserDetails: state.mainProfileState.authProviderUserDetails);
      emit(ProfileLoaded(state.mainProfileState.copyWith(user: user)));
    } catch (error) {
      emit(ProfileError(state.mainProfileState.copyWith(message: error.toString())));
    }
  }
}
