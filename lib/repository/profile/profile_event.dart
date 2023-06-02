// profile_event.dart
abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class ApplyAsCreator extends ProfileEvent {
  final Map<String, dynamic> creatorData;

  ApplyAsCreator(this.creatorData);
}

class UpdateProfile extends ProfileEvent {
  final Map<String, dynamic> creatorData;

  UpdateProfile(this.creatorData);
}