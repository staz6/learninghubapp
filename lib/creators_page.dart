import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreatorsPage extends StatefulWidget {
  @override
  _CreatorsPageState createState() => _CreatorsPageState();
}

class _CreatorsPageState extends State<CreatorsPage> {
  final _auth = FirebaseAuth.instance;

  Future<void> _subscribe(String creatorId) async {
    final user = _auth.currentUser;

    if (user != null) {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userDocRef.update({
        'subscribes': FieldValue.arrayUnion([creatorId])
      });
    }
  }

  Future<bool> _isSubscribed(String userId, String creatorId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    List<dynamic>? subscribes = userDoc['subscribes'];
    if (subscribes != null && subscribes.contains(creatorId)) {
      return true;
    }
    return false;
  }

  Widget _buildSubscribeButton(String userId, String creatorId) {
    return FutureBuilder<bool>(
      future: _isSubscribed(userId, creatorId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        bool isSubscribed = snapshot.data!;

        return ElevatedButton(
          onPressed: () async {
            await _subscribeOrUnsubscribe(userId, creatorId, isSubscribed);
          },
          child: Text(isSubscribed ? 'Unsubscribe' : 'Subscribe'),
        );
      },
    );
  }

  Future<void> _subscribeOrUnsubscribe(String userId, String creatorId, bool isSubscribed) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentReference userRef = users.doc(userId);

    if (isSubscribed) {
      // Unsubscribe the user from the creator
      await userRef.update({
        'subscribes': FieldValue.arrayRemove([creatorId]),
      });
    } else {
      // Subscribe the user to the creator
      await userRef.update({
        'subscribes': FieldValue.arrayUnion([creatorId]),
      });
    }

    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('creators').snapshots(),
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

          final creatorDocs = snapshot.data!.docs.where((doc) => doc.id != currentUserUid).toList();

          return ListView.builder(
            itemCount: creatorDocs.length,
            itemBuilder: (context, index) {
              final creator = creatorDocs[index];
              return Card(
                color: Color(0xFF2d2d2d),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        creator['fullName'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(creator['speciality']),
                      SizedBox(height: 4),
                      Text(creator['aboutMe']),
                      SizedBox(height: 4),
                      Text('Location: ${creator['country']}, ${creator['city']}'),
                      SizedBox(height: 4),
                      Text('Date of birth: ${creator['dateOfBirth']}'),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildSubscribeButton(currentUserUid, creator.id),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}