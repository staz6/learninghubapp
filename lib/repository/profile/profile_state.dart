// profile_state.dart
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> creatorData;
  final bool isCreator;

  ProfileLoaded(this.creatorData, this.isCreator);
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}