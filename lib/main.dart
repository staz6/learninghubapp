import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learninghubapp/auth_provider.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'news_feed_page.dart';
import 'package:provider/provider.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
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
        home: AuthHandler(),
      ),
    );
  }
}

class AuthHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return authProvider.loggedIn == null
        ? CircularProgressIndicator()
        : authProvider.loggedIn!
            ? NewsFeedPage()
            : LoginPage();
  }
}
