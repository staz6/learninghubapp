import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'new_post_event.dart';
import 'new_post_state.dart';

class NewPostBloc extends Bloc<NewPostEvent, NewPostState> {
  NewPostBloc() : super(NewPostInitial()) {
    on<SubmitPost>(_onSubmitPost);
  }

  Future<void> _onSubmitPost(
      SubmitPost event, Emitter<NewPostState> emit) async {
    emit(NewPostLoading());
    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'title': event.title,
        'description': event.description,
        'likes': [],
        'isPrivate': event.isPrivate,
        'creatorId': event.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      emit(NewPostSuccess());
    } catch (error) {
      print(error);
    }
  }
}
