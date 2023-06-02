import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'news_feed_event.dart';
import 'news_feed_state.dart';

class NewsFeedBloc extends Bloc<NewsFeedEvent, NewsFeedState> {
  NewsFeedBloc() : super(NewsFeedLoading());

  @override
  Stream<NewsFeedState> mapEventToState(NewsFeedEvent event) async* {
    if (event is LoadNewsFeed) {
      yield* _mapLoadNewsFeedToState(event);
    } else if (event is LikeUnlikePost) {
      yield* _mapLikeUnlikePostToState(event);
    }
  }

  Stream<NewsFeedState> _mapLoadNewsFeedToState(LoadNewsFeed event) async* {
    try {
      yield NewsFeedLoading();

      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserUid).get();
      List<dynamic> subscribes = userDoc['subscribes'] ?? [];

      QuerySnapshot postDocs = await FirebaseFirestore.instance.collection('posts').get();

      List<DocumentSnapshot> posts = event.isPrivateFeed
          ? postDocs.docs.where((doc) => doc['isPrivate'] == true && subscribes.contains(doc['creatorId'])).toList()
          : postDocs.docs.where((doc) => doc['isPrivate'] == false).toList();

      yield NewsFeedLoaded(posts);
    } catch (error) {
      yield NewsFeedError(error.toString());
    }
  }

  Stream<NewsFeedState> _mapLikeUnlikePostToState(LikeUnlikePost event) async* {
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference posts = FirebaseFirestore.instance.collection('posts');
      DocumentReference postRef = posts.doc(event.postId);

      if (event.isLiked) {
        // Remove the user from the post's likes array
        postRef.update({
          'likes': FieldValue.arrayRemove([currentUserUid]),
        });
      } else {
        // Add the user to the post's likes array
        postRef.update({
          'likes': FieldValue.arrayUnion([currentUserUid]),
        });
      }

      // Refresh the UI by re-emitting the current state
      yield state;
    } catch (error) {
      yield NewsFeedError(error.toString());
    }
  }
}
