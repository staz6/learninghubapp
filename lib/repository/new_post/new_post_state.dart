abstract class NewPostEvent {}

class SubmitPost extends NewPostEvent {
  final String title;
  final String description;
  final bool isPrivate;
  final String uid;

  SubmitPost({
    required this.title,
    required this.description,
    required this.isPrivate,
    required this.uid,
  });
}
