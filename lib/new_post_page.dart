import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart'; 
class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}




class _NewPostPageState extends State<NewPostPage> {
  final _titleController = TextEditingController();
final _descriptionController = TextEditingController();
bool _isPrivate = false;
void _submitPost() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    FirebaseFirestore.instance.collection('posts').add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'likes': [],
      'isPrivate': _isPrivate,
      'creatorId': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post created successfully')),
      );
      
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $error')),
      );
    });
  }
}
  @override
Widget build(BuildContext context) {
  final authProvider = Provider.of<AuthProvider>(context); // Access AuthProvider
  bool? isCreator = authProvider.isCreator; // Get isCreator field
  return Scaffold(
    
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'Enter the title of your post',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Enter the description of your post',
            ),
            maxLines: 5,
          ),
          SizedBox(height: 16),
          if (isCreator ?? false) 
              Row(
                children: [
                  Text('Private post'),
                  SizedBox(width: 8),
                  Switch(
                    value: _isPrivate,
                    onChanged: (value) {
                      setState(() {
                        _isPrivate = value;
                      });
                    },
                  ),
                ],
              ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitPost,
            child: Text('Create Post'),
          ),
        ],
      ),
    ),
  );
}

}