import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

   AuthBloc({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_authCheckRequested);
    on<SignedOut>(_signedOut);
    on<LogInRequested>(_logInRequested);
    on<SignUpRequested>(_signUpRequested);

    add(AuthCheckRequested());
  }

  Future<void> _authCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
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

  Future<void> _logInRequested(
      LogInRequested event, Emitter<AuthState> emit) async {
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
      emit(AuthFailure(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _signUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': event.username,
          'fullname': event.fullname,
          'email': event.email,
          'subscribes': [],
        });
        final creatorDoc =
            await _firestore.collection('creators').doc(user.uid).get();
        final isCreator = creatorDoc.exists;
        emit(Authenticated(user, isCreator));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        event.onFailure(e.message ?? "Sorry something went wrong please try again later.");
      } else {
        event.onFailure(e.toString());
      }
    }
  }
}
