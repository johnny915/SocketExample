import 'package:flutter/material.dart';
import 'package:pdfdemo/Screen/HomeScreen.dart';
import 'package:pdfdemo/Screen/SignUp.dart';

import '../Model/UserModel.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'TutorialKart',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () {
                      login();
                    },
                  )
              ),
              Row(
                children: <Widget>[
                  const Text('Does not have account?'),
                  TextButton(
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          )),
    );
  }



  void login(){
    authInst.signInWithEmailAndPassword(
        email: nameController.text.trim(),
        password: passwordController.text.trim()).then((value) {

      createdUser = UserModel(
          uid: value.user!.uid, userName: value.user!.email!, deviceToken: "", isOnline: true, caller: '', socketId: socketHelper.socketId
      );
      messaging.getToken().then((value) {
        if(value!=null){
          createdUser!.deviceToken = value;
          userRef.doc(createdUser!.uid).set(createdUser!.toJson()).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Logged in Successfully")));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("error in getting device token")));
        }
      });


    }).catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }
}
