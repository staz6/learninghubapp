import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/auth/auth_bloc.dart';
import 'package:provider/provider.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _loginBlock() {
      context.read<AuthBloc>().add(
            LogInRequested(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            ),
          );
     
  }

  @override
Widget build(BuildContext context) {
  return BlocListener<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      } else if (state is Authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Successfully')),
        );
      }
    },
    child: Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset('logo-dark.png'),  
                SizedBox(height: 10),

                Text(
                  'Learning Hub',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

                // Email field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 16),

                // Password field
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
                      onPressed: _loginBlock,
                      child: Text('Login'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text("Sign up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

}
