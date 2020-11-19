part of 'profile_cubit.dart';

class MainProfileState extends Equatable{
  final String message;
  final User user;
  final AuthProviderUserDetails authProviderUserDetails;

  MainProfileState({this.message, this.user, this.authProviderUserDetails});

  @override
  List<Object> get props => [message, user, authProviderUserDetails];

  MainProfileState copyWith({
    String message,
    User user,
    AuthProviderUserDetails authProviderUserDetails,
  }) {
    if ((message == null || identical(message, this.message)) && (user == null || identical(user, this.user)) && (authProviderUserDetails == null || identical(authProviderUserDetails, this.authProviderUserDetails))) {
      return this;
    }

    return new MainProfileState(
      message: message ?? this.message,
      user: user ?? this.user,
      authProviderUserDetails: authProviderUserDetails ?? this.authProviderUserDetails,
    );
  }
}

abstract class ProfileState extends Equatable {
  final MainProfileState mainProfileState;

  ProfileState(this.mainProfileState);

  @override
  List<Object> get props => [mainProfileState];
}

class ProfileInitial extends ProfileState {
  ProfileInitial() : super(MainProfileState());
}

class ProfileLoading extends ProfileState {
  ProfileLoading(MainProfileState mainProfileState) : super(mainProfileState);
}

class ProfileLoaded extends ProfileState {
  ProfileLoaded(MainProfileState mainProfileState) : super(mainProfileState);
}

class ProfileUpdating extends ProfileState {
  ProfileUpdating(MainProfileState mainProfileState) : super(mainProfileState);
}

class ProfileError extends ProfileState {
  ProfileError(MainProfileState mainProfileState) : super(mainProfileState);
}
