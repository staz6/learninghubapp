import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  // Update the button text based on isCreator
  String buttonText = isCreator ? 'Creator' : 'Apply as Creator';

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
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
  );
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: _getCreatorDocument(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            bool isCreator = false;
            Map<String, dynamic> creatorData = {};

            if (snapshot.hasData && snapshot.data!.exists) {
              isCreator = true;
              creatorData = snapshot.data!.data() as Map<String, dynamic>;
            }

            return _buildProfileUI(context, isCreator, creatorData);
          },
        ),
      ),
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
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        print("here");
        await FirebaseFirestore.instance
            .collection('creators')
            .doc(currentUser.uid)
            .set({
          'fullName': fullNameController.text,
          'speciality': specialityController.text,
          'aboutMe': aboutMeController.text,
          'country': countryController.text,
          'city': cityController.text,
          'dateOfBirth': dateOfBirthController.text,
        });
        if (isCreator) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully updated information')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully applied as creator')),
          );
        }
        Navigator.of(context).pop(); // Close the form
      } catch (e) {
        // Handle the error
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sorry something went wrong')),
        );
      }
    } else {
      print('User is not signed in');
    }
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
