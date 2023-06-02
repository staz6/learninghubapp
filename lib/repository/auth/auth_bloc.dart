import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_authCheckRequested);
    on<SignedOut>(_signedOut);
    on<LogInRequested>(_logInRequested);

    add(AuthCheckRequested());
  }

  Future<void> _authCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(Unauthenticated());
    } else {
      final creatorDoc = await FirebaseFirestore.instance
          .collection('creators')
          .doc(user.uid)
          .get();
      final isCreator = creatorDoc.exists;
      emit(Authenticated(user, isCreator));
    }
  }

  Future<void> _signedOut(SignedOut event, Emitter<AuthState> emit) async {
    await _auth.signOut();
    emit(Unauthenticated());
  }

   Future<void> _logInRequested(LogInRequested event, Emitter<AuthState> emit) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      User? user = userCredential.user;
      if (user != null) {
        final creatorDoc = await FirebaseFirestore.instance
            .collection('creators')
            .doc(user.uid)
            .get();
        final isCreator = creatorDoc.exists;
        emit(Authenticated(user, isCreator));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      print(e);
    }
  }
}
