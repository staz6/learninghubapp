import 'package:flutter/material.dart';
import 'news_feed_page.dart';
import 'new_post_page.dart';
import 'chat_page.dart';
import 'profile_page.dart';
import 'creators_page.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class LayoutPage extends StatefulWidget {
  final Widget body;
  final String currentPage;
  LayoutPage({required this.body, required this.currentPage});

  @override
  _LayoutPageState createState() => _LayoutPageState();

  
}

class _LayoutPageState extends State<LayoutPage> {
  void _navigateToPage(Widget page, String pageName) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LayoutPage(body: page, currentPage: pageName,),
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
              leading: Icon(Icons.article,color: Color(0xFF1b1b1b)),
              title: Text('News Feed',style: TextStyle(color: Colors.white)),
              onTap: () {
                _navigateToPage(NewsFeedPage(),'News Feed');
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box,color: Color(0xFF1b1b1b)),
              title: Text('New Post',style: TextStyle(color: Colors.white)),
              onTap: () {
                 _navigateToPage(NewPostPage(), 'New Post');
              },
            ),
            ListTile(
              leading: Icon(Icons.chat,color: Color(0xFF1b1b1b)),
              title: Text('Chat',style: TextStyle(color: Colors.white)),
              onTap: () {
                _navigateToPage(ChatPage(), 'Chat');
              },
            ),
            ListTile(
              leading: Icon(Icons.chat,color: Color(0xFF1b1b1b)),
              title: Text('Creator',style: TextStyle(color: Colors.white)),
              onTap: () {
                _navigateToPage(CreatorsPage(), 'Creator');
              },
            ),
            ListTile(
              leading: Icon(Icons.person,color: Color(0xFF1b1b1b)),
              title: Text('Profile',style: TextStyle(color: Colors.white)),
              onTap: () {
                _navigateToPage(ProfilePage(), 'Profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout,color: Color(0xFF1b1b1b)),
              title: Text('Sign Out',style: TextStyle(color: Colors.white)),
              onTap: () {
                _signOut(context);
              },
            ),
          ],
        ),
        ),
      ),
    );
  }
}
