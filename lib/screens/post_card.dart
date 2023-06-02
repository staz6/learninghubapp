import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learninghubapp/repository/news_feed/news_feed_bloc.dart';
import 'package:learninghubapp/repository/news_feed/news_feed_event.dart';

class PostCard extends StatefulWidget {
  final DocumentSnapshot post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  late ValueNotifier<bool> isLiked;

  void _handleLikeUnlike() {
    isLiked.value = !isLiked.value;
    context.read<NewsFeedBloc>().add(LikeUnlikePost(widget.post.id, isLiked.value));
  }

  @override
  void initState() {
    super.initState();
    isLiked = ValueNotifier<bool>(widget.post['likes'].contains(currentUserUid));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.post['creatorId'])
          .get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final creator = snapshot.data!;
        
        return Card(
          color: Color(0xFF2d2d2d),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  creator['fullname'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(widget.post['title']),
                SizedBox(height: 4),
                Text(widget.post['description']),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: isLiked,
                      builder: (BuildContext context, bool value, Widget? child) {
                        return IconButton(
                          onPressed: _handleLikeUnlike,
                          icon: Icon(
                            Icons.favorite,
                            color: value ? Colors.red : Colors.grey,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
