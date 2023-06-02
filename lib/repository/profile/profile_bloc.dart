import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'profile_event.dart';
import 'profile_state.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ApplyAsCreator>(_onApplyAsCreator);
  }

  Future<DocumentSnapshot> _getCreatorDocument() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('creators')
          .doc(user.uid)
          .get();
    }
    throw Exception('User not logged in');
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      final doc = await _getCreatorDocument();
      bool isCreator = false;
      Map<String, dynamic> creatorData = {};
      if (doc.exists) {
        isCreator = true;
        creatorData = doc.data() as Map<String, dynamic>;
      }
      emit(ProfileLoaded(creatorData, isCreator));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

   Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('creators')
            .doc(currentUser.uid)
            .set(event.creatorData);
        emit(ProfileLoaded(event.creatorData, true));
      } else {
        throw Exception('User not logged in');
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onApplyAsCreator(ApplyAsCreator event, Emitter<ProfileState> emit) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('creators')
            .doc(currentUser.uid)
            .set(event.creatorData);
        emit(ProfileLoaded(event.creatorData, true));
      } else {
        throw Exception('User not logged in');
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
