import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounted_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 80.0,
              ),
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/chat2.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter Your Email Address'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                 password = value;
                },
                decoration:kTextFieldDecoration.copyWith(hintText: 'Enter Your Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
             RoundedButton(onPresses: () async {
               try {
                 final newUser = await _auth.createUserWithEmailAndPassword(
                     email: email, password: password);
                 if(newUser != null)
                   Navigator.pushNamed(context, ChatScreen.id);
               }
               catch(e){
                 print(e);
               }
             }, title: 'Registration',colour: Colors.blueAccent,),
              // SizedBox(
              //   height: 24.0,
              // ),
              // RoundedButton(onPresses: (){}, title: 'Registration',colour: Colors.blueAccent,),
              // SizedBox(
              //   height: 24.0,
              // ),
              // RoundedButton(onPresses: (){}, title: 'Registration',colour: Colors.blueAccent,),
              // SizedBox(
              //   height: 24.0,
              // ),
              // RoundedButton(onPresses: (){}, title: 'Registration',colour: Colors.blueAccent,)

            ],
          ),
        ),
      ),
    );
  }
}
