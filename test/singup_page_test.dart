import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learninghubapp/repository/auth/auth_bloc.dart';
import 'package:learninghubapp/screens/signup_page.dart';
import 'package:mockito/mockito.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late AuthBloc mockAuthBloc; 

  setUp(() {
    // Initialize the mock before each test
    mockAuthBloc = MockAuthBloc();
  });

  testWidgets('SignUpPage should contain four fields and two buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockAuthBloc,
          child: SignUpPage(),
        ),
      ),
    );

    // Assert that the four fields and two buttons are present
    expect(find.byType(TextField), findsNWidgets(4));
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });
}