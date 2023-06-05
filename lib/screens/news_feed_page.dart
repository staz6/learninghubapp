import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learninghubapp/component/post_card.dart';
import '../repository/news_feed/news_feed_bloc.dart';
import '../repository/news_feed/news_feed_event.dart';
import '../repository/news_feed/news_feed_state.dart';

class NewsFeedPage extends StatefulWidget {
  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  late NewsFeedBloc _bloc;
  bool _isPrivateFeed = false;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<NewsFeedBloc>();
    _bloc.add(LoadNewsFeed(isPrivateFeed: _isPrivateFeed));
  }

  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  



  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1b1b1b),
        actions: [
          IconButton(
            icon: Icon(_isPrivateFeed ? Icons.lock : Icons.lock_open),
            onPressed: () {
              setState(() {
                _isPrivateFeed = !_isPrivateFeed;
                _bloc.add(LoadNewsFeed(isPrivateFeed: _isPrivateFeed));
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<NewsFeedBloc, NewsFeedState>(
        builder: (context, state) {
          if (state is NewsFeedLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NewsFeedLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return PostCard(post: post);
              },
            );
          } else if (state is NewsFeedError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
