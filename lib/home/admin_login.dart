import 'package:base/architecture/backend/firebase_storage_api.dart';
import 'package:base/architecture/widget_default/__appbar.dart';
import 'package:base/architecture/widget_default/__button.dart';
import 'package:base/architecture/widget_default/__textbox.dart';
import 'package:base/architecture/widget_default/__toast.dart';
import 'package:base/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  bool isLoadingComplete = true;
  final _username = TextEditingController();
  final _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: 'Admin Login Page', foreground: Colors.black, systemNavigationBarColor: Colors.grey.shade300),
      backgroundColor: Colors.grey.shade300,
      body: Container(
        height: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            myTextBox(controller: _username, backgroundColor: Colors.white, hint: 'username'),
            myTextBox(controller: _password, obsecureText: true, backgroundColor: Colors.white, hint: 'password'),
            myButton(
                action: () async {
                  setState(() => isLoadingComplete = false);
                  DatabaseReference ref = FirebaseApi.connect.child('admin/${_username.text.trim()}');
                  final snapshot = await ref.get();
                  if (snapshot.exists) {
                    if (snapshot.child('user').value == _username.text) {
                      if (snapshot.child('pass').value == _password.text) {
                        myToast(msg: 'welcome');
                        setState(() => isLoadingComplete = true);
                        if (mounted) Navigator.pushNamed(context, MyRoutes.adminMenu);
                        return;
                      }
                    }
                  }
                  myToast(msg: 'wrong credentials');
                  setState(() => isLoadingComplete = true);
                },
                label: 'Sign in',
                background: Colors.amber.shade800,
                isLoadingComplete: isLoadingComplete),
          ],
        ),
      ),
    );
  }
}
