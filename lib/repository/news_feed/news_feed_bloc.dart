import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'news_feed_event.dart';
import 'news_feed_state.dart';

class NewsFeedBloc extends Bloc<NewsFeedEvent, NewsFeedState> {
  NewsFeedBloc() : super(NewsFeedLoading()) {
    on<LoadNewsFeed>(_loadNewsFeed);
    on<LikeUnlikePost>(_likeUnlikePost);
  }

  Future<void> _loadNewsFeed(
      LoadNewsFeed event, Emitter<NewsFeedState> emit) async {
    emit(NewsFeedLoading());
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();
      List<dynamic> subscribes = userDoc['subscribes'] ?? [];
      QuerySnapshot postDocs =
          await FirebaseFirestore.instance.collection('posts').get();

      List<DocumentSnapshot> posts = event.isPrivateFeed
          ? postDocs.docs
              .where((doc) =>
                  doc['isPrivate'] == true &&
                  subscribes.contains(doc['creatorId']))
              .toList()
          : postDocs.docs.where((doc) => doc['isPrivate'] == false).toList();

      emit(NewsFeedLoaded(posts));
    } catch (e) {
      emit(NewsFeedError(e.toString()));
    }
  }

  Future<void> _likeUnlikePost(
    LikeUnlikePost event, Emitter<NewsFeedState> emit) async {
  try {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference posts =
        FirebaseFirestore.instance.collection('posts');
    DocumentReference postRef = posts.doc(event.postId);
    print(event);
    if (event.isLiked) {
      // User liked the post, add the user to the post's likes array
      print("like post");
      postRef.update({
        'likes': FieldValue.arrayUnion([currentUserUid]),
      });
    } else {
      // User unliked the post, remove the user from the post's likes array
      print("unlike post");
      postRef.update({
        'likes': FieldValue.arrayRemove([currentUserUid]),
      });
    }
    emit(state);
  } catch (e) {
    print(e);
    emit(NewsFeedError(e.toString()));
  }
}

}
