import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learninghubapp/repository/profile/profile_bloc.dart';
import 'package:learninghubapp/repository/profile/profile_event.dart';
import 'package:learninghubapp/repository/profile/profile_state.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

Future<DocumentSnapshot> _getCreatorDocument() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return FirebaseFirestore.instance
        .collection('creators')
        .doc(user.uid)
        .get();
  }
  return Future.error('User not logged in');
}

Widget _buildProfileUI(
    BuildContext context, bool isCreator, Map<String, dynamic> creatorData) {
  String buttonText = isCreator ? 'Creator' : 'Apply as Creator';

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          child: Icon(Icons.person, size: 50),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          child: Text(buttonText),
          onPressed: () {
            _showApplyAsCreatorForm(
              context,
              isCreator,
              TextEditingController(text: creatorData['fullName'] ?? ''),
              TextEditingController(text: creatorData['speciality'] ?? ''),
              TextEditingController(text: creatorData['aboutMe'] ?? ''),
              TextEditingController(text: creatorData['country'] ?? ''),
              TextEditingController(text: creatorData['city'] ?? ''),
              TextEditingController(text: creatorData['dateOfBirth'] ?? ''),
            );
          },
        ),
      ],
    ),
  );
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ProfileBloc>();
    _bloc.add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProfileLoaded) {
          return _buildProfileUI(context, state.isCreator, state.creatorData);
        } else if (state is ProfileError) {
          return Center(child: Text('Error: ${state.error}'));
        }
        return SizedBox.shrink();
      },
    );
  }
}

void _showApplyAsCreatorForm(
  BuildContext context,
  bool isCreator,
  TextEditingController fullNameController,
  TextEditingController specialityController,
  TextEditingController aboutMeController,
  TextEditingController countryController,
  TextEditingController cityController,
  TextEditingController dateOfBirthController,
) {
  Future<void> _submitForm() async {
    Map<String, dynamic> creatorData = {
      'fullName': fullNameController.text,
      'speciality': specialityController.text,
      'aboutMe': aboutMeController.text,
      'country': countryController.text,
      'city': cityController.text,
      'dateOfBirth': dateOfBirthController.text,
    };
    if (isCreator) {
      context.read<ProfileBloc>().add(UpdateProfile(creatorData));
    } else {
      context.read<ProfileBloc>().add(ApplyAsCreator(creatorData));
    }
    Navigator.of(context).pop(); 
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(
            16.0), // Adjust the padding to control the overall size of the popup
        title: Text(isCreator  ? 'Welcome Creator' : 'Apply as Creator'),
        backgroundColor: Color(0xFF2d2d2d),
        content: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
                TextField(
                  controller: specialityController,
                  decoration: InputDecoration(labelText: 'Speciality'),
                ),
                TextField(
                  controller: aboutMeController,
                  decoration: InputDecoration(labelText: 'About Me'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 5,
                ),
                TextField(
                  controller: countryController,
                  decoration: InputDecoration(labelText: 'Country'),
                ),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'City'),
                ),
                TextField(
                  controller: dateOfBirthController,
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              _submitForm();
            },
          ),
        ],
      );
    },
  );
}
