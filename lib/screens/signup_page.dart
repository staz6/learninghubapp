import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repository/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();



  void _signUpBloc() {
    if (_usernameController.text.trim().isEmpty ||
        _fullnameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
    } else {
      context.read<AuthBloc>().add(
        SignUpRequested(
          username: _usernameController.text.trim(),
          fullname: _fullnameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          onFailure: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $message')),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Image.asset('logo-dark.png'),  
                SizedBox(height: 10),
                
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Knowledge. Humility. ',style: TextStyle(
                          color: Color(0xFFFFFFFF),
                        ),),
                      TextSpan(
                        text: 'Character',
                        style: TextStyle(
                          color: Color(0xFFF0B032),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Registry Yourself',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAAAAAA)
                  ),
                ),
                SizedBox(height: 10),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _fullnameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 16),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _signUpBloc,
                  child: Text('Sign Up'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text("Login"),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }
}
