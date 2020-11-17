import 'package:bloc/bloc.dart';
import 'package:distressoble/Model/UserModel.dart';
import 'package:distressoble/store/firebase_user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AppUserProfileRepository _user;
  ProfileCubit({@required AppUserProfileRepository user})
      : _user = user,
        super(ProfileInitial());

  loadProfile() async {
    emit(ProfileLoading(message: 'Loading...', authProviderUserDetails: state.authProviderUserDetails, user: state.user));
    try {
      User user = await _user.getUserProfile();
      AuthProviderUserDetails authProviderUserDetails = await AuthProviderRepository().loadUserFromPrefs();
      emit(ProfileLoaded(user: user, authProviderUserDetails: authProviderUserDetails));
    } catch (error) {
      emit(ProfileError(message: error.toString(), authProviderUserDetails: state.authProviderUserDetails, user: state.user));
    }
  }

  updateProfile(User user) async {
    emit(ProfileUpdating(message: 'Loading...', authProviderUserDetails: state.authProviderUserDetails, user: user));
    try {
      await _user.updateUserProfile(userProfile: user, authProviderUserDetails: state.authProviderUserDetails);
      emit(ProfileLoaded(user: user, authProviderUserDetails: state.authProviderUserDetails));
    } catch (error) {
      emit(ProfileError(message: error.toString(), authProviderUserDetails: state.authProviderUserDetails, user: state.user));
    }
  }
}
