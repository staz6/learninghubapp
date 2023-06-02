import 'package:cloud_firestore/cloud_firestore.dart';

abstract class NewsFeedState {}

class NewsFeedLoading extends NewsFeedState {}

class NewsFeedLoaded extends NewsFeedState {
  final List<DocumentSnapshot> posts;

  NewsFeedLoaded(this.posts);
}

class NewsFeedError extends NewsFeedState {
  final String error;

  NewsFeedError(this.error);
}
