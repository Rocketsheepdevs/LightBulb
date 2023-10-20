import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class User {
  String username;
  String password;
  String confirmPassword;
  String name;
  String gender;
  DateTime birthday;

  User({
    required this.username,
    required this.password,
    required this.confirmPassword,
    required this.name,
    required this.gender,
    required this.birthday,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NewUserPage(),
    );
  }
}

class NewUserPage extends StatefulWidget {
  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String gender = 'Male'; // Default gender
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ))!;
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            Row(
              children: [
                Text('Gender:'),
                Radio(
                  value: 'Male',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                Text('Male'),
                Radio(
                  value: 'Female',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            Row(
              children: [
                Text('Birthday:'),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                ),
                SizedBox(width: 10),
                Text(selectedDate != null
                    ? "${selectedDate!.toLocal()}".split(' ')[0]
                    : 'No Date Selected'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Create User object with entered data
                User newUser = User(
                  username: usernameController.text,
                  password: passwordController.text,
                  confirmPassword: confirmPasswordController.text,
                  name: nameController.text,
                  gender: gender,
                  birthday: selectedDate ?? DateTime.now(),
                );

                // Do something with the new user data, e.g., save to a database
                print('New User: $newUser');
              },
              child: Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }
}
