import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learninghubapp/repository/auth/auth_bloc.dart';

class MockUser extends Mock implements User {
  @override
  String get uid => 'testUserId';
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<void> signOut() async {}
}

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockFirebaseAuth mockFirebaseAuth;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      fakeFirestore = FakeFirebaseFirestore();
      authBloc = AuthBloc(auth: mockFirebaseAuth, firestore: fakeFirestore);
    });


    test('initial state is Unauthenticated', () {
      expect(authBloc.state, equals( Unauthenticated()));
    });

  });
}
