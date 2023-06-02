import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository/auth/auth_bloc.dart';
import 'helper/firebase_options.dart';
import 'screens/login_page.dart';
import 'layout/layout_page.dart';
import 'screens/news_feed_page.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color(0xFFF0B032),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFFFFFFF)),
          backgroundColor: Color(0xFF1b1b1b),
          scaffoldBackgroundColor: Color(0xFF1b1b1b),
          appBarTheme: AppBarTheme(backgroundColor: Color(0xFFF0B032)),
          textTheme: ThemeData.light().textTheme.apply(
                bodyColor: Color(0xFFFFFFFF),
                displayColor: Color(0xFFFFFFFF),
              ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle:
                TextStyle(color: Color(0xFFAAAAAA)), // Lighter shade of white
            hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF0B032)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF0B032)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFFF0B032)),
              foregroundColor: MaterialStateProperty.all(Color(0xFFFFFFFF)),
            ),
          ),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) => AuthHandler(state: state),
        ),
      ),
    );
  }
}

class AuthHandler extends StatelessWidget {
  final AuthState state;

  AuthHandler({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is Authenticated) {
      return LayoutPage(body: NewsFeedPage(), currentPage: 'News Feed');
    } else if (state is Unauthenticated) {
      return LoginPage();
    } else {
      return CircularProgressIndicator();
    }
  }
}
