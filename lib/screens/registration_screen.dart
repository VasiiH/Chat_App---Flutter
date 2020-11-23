import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounted_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {


  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email;
  String password;

  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                  //Do something with the user input.
                  password = value;
                },
                decoration:kTextFieldDecoration.copyWith(hintText: 'Enter Your Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
             RoundedButton(onPresses: () async {
               setState(() {
                 showSpinner = true;
               });
               try {
                 final newUser = await _auth.createUserWithEmailAndPassword(
                     email: email, password: password);
                 if(newUser != null){
                   Navigator.pushNamed(context, ChatScreen.id);
                 }
                 setState(() {
                   showSpinner = false;
                 });               }
               catch(e){
                  print(e);
               }
               }, title: 'Registration',colour: Colors.blueAccent,)
            ],
          ),
        ),
      ),
    );
  }
}
