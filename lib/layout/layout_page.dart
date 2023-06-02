import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learninghubapp/repository/new_post/new_post_bloc.dart';
import 'package:learninghubapp/repository/news_feed/news_feed_bloc.dart';
import 'package:learninghubapp/repository/profile/profile_bloc.dart';
import '../screens/news_feed_page.dart';
import '../screens/new_post_page.dart';
import '../screens/chat_page.dart';
import '../screens/profile_page.dart';
import '../screens/creators_page.dart';
import '../repository/chat/chat_bloc.dart';
import 'package:provider/provider.dart';
import '../helper/auth_provider.dart';
import '../repository/auth/auth_bloc.dart';

class LayoutPage extends StatefulWidget {
  final Widget body;
  final String currentPage;
  LayoutPage({required this.body, required this.currentPage});

  @override
  _LayoutPageState createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  void _navigateToPage(Widget page, String pageName) {
    Widget body;
    if (pageName == 'Chat') {
      body = BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(currentUserUid),
        child: ChatPage(),
      );
    } else if (pageName == "Profile") {
      body = BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(),
        child: ProfilePage(),
      );
    } else if (pageName == 'News Feed') {
      body = BlocProvider<NewsFeedBloc>(
        create: (context) => NewsFeedBloc(),
        child: NewsFeedPage(),
      );
    } else if (pageName == "New Post"){
      body = BlocProvider<NewPostBloc>(
        create: (context) => NewPostBloc(),
        child: NewPostPage(),
      );
    } 
    else {
      print("we in in else pageName");
      body = page;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LayoutPage(
          body: body,
          currentPage: pageName,
        ),
      ),
    );
  }

  void _signOut(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signOut();
    } catch (e) {
      print(e);
    }
  }

  void _signOutBlock(BuildContext context) {
    context.read<AuthBloc>().add(SignedOut());
    
  }

  TextStyle _listTileTextStyle(String pageName) {
    return TextStyle(
      fontWeight:
          widget.currentPage == pageName ? FontWeight.bold : FontWeight.normal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.currentPage)),
      body: widget.body,
      drawer: Drawer(
        child: Container(
          color: Color(0xFFF0B032),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.article, color: Color(0xFF1b1b1b)),
                title: Text('News Feed', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _navigateToPage(NewsFeedPage(), 'News Feed');
                },
              ),
              ListTile(
                leading: Icon(Icons.add_box, color: Color(0xFF1b1b1b)),
                title: Text('New Post', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _navigateToPage(NewPostPage(), 'New Post');
                },
              ),
              ListTile(
                leading: Icon(Icons.chat, color: Color(0xFF1b1b1b)),
                title: Text('Chat', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _navigateToPage(ChatPage(), 'Chat');
                },
              ),
              ListTile(
                leading: Icon(Icons.chat, color: Color(0xFF1b1b1b)),
                title: Text('Creator', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _navigateToPage(CreatorsPage(), 'Creator');
                },
              ),
              ListTile(
                leading: Icon(Icons.person, color: Color(0xFF1b1b1b)),
                title: Text('Profile', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _navigateToPage(ProfilePage(), 'Profile');
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Color(0xFF1b1b1b)),
                title: Text('Sign Out', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _signOutBlock(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
