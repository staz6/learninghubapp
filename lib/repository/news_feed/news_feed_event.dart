abstract class NewsFeedEvent {}

class LoadNewsFeed extends NewsFeedEvent {
  final bool isPrivateFeed;

  LoadNewsFeed({this.isPrivateFeed = false});
}

class LikeUnlikePost extends NewsFeedEvent {
  final String postId;
  final bool isLiked;

  LikeUnlikePost(this.postId, this.isLiked);
}
