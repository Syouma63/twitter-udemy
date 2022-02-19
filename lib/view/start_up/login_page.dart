import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:twitter/utils/authentication.dart';
import 'package:twitter/utils/firestore/users.dart';
import 'package:twitter/view/screen.dart';
import 'package:twitter/view/start_up/create_account_page.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 50,),
              const Text('Flutterラボ SNS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'メールアドレス'
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: passController,
                  decoration: const InputDecoration(
                      hintText: 'パスワード'
                  ),
                ),
              ),
             const SizedBox(height: 10),
             RichText(
                 text: TextSpan(
                   style: const TextStyle(color: Colors.black),
                   children: [
                     const TextSpan(text: 'アカウントを作成してない方は'),
                     TextSpan(text: 'こちら',
                       style: const TextStyle(color: Colors.blue),
                       recognizer: TapGestureRecognizer()..onTap = () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
                       }
                     )
                   ]
                 ),
             ),
              const SizedBox(height: 70),
              ElevatedButton(
                  onPressed: () async {
                    var result = await Authentication.emailSignIn(email: emailController.text, pass: passController.text);
                    if(result is UserCredential) {
                      if(result.user!.emailVerified == true) {
                        var _result = await UserFirestore.getUser(result.user!.uid);
                        if(_result == true) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screen()));
                        }
                      } else {
                        print('メール認証できてません');
                      }

                    }
                  },
                  child: const Text('emailでログイン')
              ),
              SignInButton(
                  Buttons.Google,
                  onPressed: () async{
                    var result = await Authentication.signInWithGoogle();
                    if (result is UserCredential) {
                      var result = await UserFirestore.getUser(Authentication.currentFirebaseUser!.uid);
                      if(result == true) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screen()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
                      }
                    }
                  })
            ],
          ),
        ),
      )
    );
  }
}
