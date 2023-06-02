import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/new_post/new_post_bloc.dart';
import '../repository/new_post/new_post_event.dart';
import '../repository/new_post/new_post_state.dart';
import '../repository/auth/auth_bloc.dart';
import 'package:provider/provider.dart';
import '../helper/auth_provider.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isPrivate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is Authenticated) {
            return BlocConsumer<NewPostBloc, NewPostState>(
              listener: (context, newPostState) {
                if (newPostState is NewPostSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Post created successfully')),
                  );
                  _titleController.clear();
                  _descriptionController.clear();
                } 
              },
              builder: (context, newPostState) {
                return SingleChildScrollView(
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
                      if (authState.isCreator)
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
                        onPressed: () => context.read<NewPostBloc>().add(
                          SubmitPost(
                            title: _titleController.text,
                            description: _descriptionController.text,
                            isPrivate: _isPrivate,
                            uid: authState.user.uid,
                          ),
                        ),
                        child: Text('Create Post'),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
