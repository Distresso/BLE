part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  final String message;
  final User user;
  final AuthProviderUserDetails authProviderUserDetails;

  ProfileState({this.message, this.user, this.authProviderUserDetails});

  @override
  List<Object> get props => [message, user, authProviderUserDetails];
}

class ProfileInitial extends ProfileState {
  ProfileInitial() : super(message: null, user: null, authProviderUserDetails: null);
}

class ProfileLoading extends ProfileState {
  ProfileLoading({String message, @required User user, @required AuthProviderUserDetails authProviderUserDetails}) : super(message: message, user: user, authProviderUserDetails: authProviderUserDetails);
}

class ProfileLoaded extends ProfileState {
  ProfileLoaded({String message, @required User user, @required AuthProviderUserDetails authProviderUserDetails}) : super(message: message, user: user, authProviderUserDetails: authProviderUserDetails);
}

class ProfileUpdating extends ProfileState {
  ProfileUpdating({String message, @required User user, @required AuthProviderUserDetails authProviderUserDetails}) : super(message: message, user: user, authProviderUserDetails: authProviderUserDetails);
}

class ProfileError extends ProfileState {
  ProfileError({String message, @required User user, @required AuthProviderUserDetails authProviderUserDetails}) : super(message: message, user: user, authProviderUserDetails: authProviderUserDetails);
}
