import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewsFeedPage extends StatefulWidget {
  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  bool _isPrivateFeed = false;
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> _likeOrUnlikePost(String postId, String userId, bool isLiked) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    DocumentReference postRef = posts.doc(postId);

    if (isLiked) {
      // Remove the user from the post's likes array
      postRef.update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } else {
      // Add the user to the post's likes array
      postRef.update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    }

    setState(() {}); // Refresh the UI
  }

  Future<DocumentSnapshot> _getUserDocument() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  }
  return Future.error('User not logged in');
}

  Widget _buildPostCard(BuildContext context, DocumentSnapshot post) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(post['creatorId']).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final creator = snapshot.data!;
        final isLiked = post['likes'].contains(currentUserUid);

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
                Text(post['title']),
                SizedBox(height: 4),
                Text(post['description']),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => _likeOrUnlikePost(post.id, currentUserUid, isLiked),
                      icon: Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
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
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getUserDocument(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
          if (!userSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<dynamic> subscribes = userSnapshot.data!['subscribes'] ?? [];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final postDocs = _isPrivateFeed
                  ? snapshot.data!.docs.where((doc) => doc['isPrivate'] == true && subscribes.contains(doc['creatorId'])).toList()
                  : snapshot.data!.docs.where((doc) => doc['isPrivate'] == false).toList();

              return ListView.builder(
                itemCount: postDocs.length,
                itemBuilder: (context, index) {
                  final post = postDocs[index];
                  return _buildPostCard(context, post);
                },
              );
            },
          );
        },
      ),
    );
  }





}
