import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pdfdemo/Screen/ApiClient.dart';
import 'package:pdfdemo/SocketHelper.dart';

import 'Model/UserModel.dart';
import 'Screen/CallingScreen.dart';
import 'Screen/HomeScreen.dart';
import 'Screen/LoginScreen.dart';
import 'Screen/SignUp.dart';
import 'Screen/SocketTesting.dart';
import 'Screen/SplashScreen.dart';
import 'firebase_options.dart';

final userRef = FirebaseFirestore.instance.collection('user');
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FirebaseAuth authInst = FirebaseAuth.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;

const appId = "53d1bde7af10469f858cfafdcb561a57";
const appCertificate = "e0acdc5d4cec48f28ea17fb702ddeada";

UserModel? createdUser;
late SocketHelper socketHelper;
late DioClient client;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   socketHelper = SocketHelper();
   client = DioClient();


  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  if(authInst.currentUser!=null){
    userRef.doc(authInst.currentUser!.uid).snapshots().listen((querySnapshot) {

      String field =querySnapshot.get("caller");
      if(field!=""){
       Navigator.push(navigatorKey.currentState!.context, MaterialPageRoute(builder: (context) =>  CallingScreen( token: field.split(",")[0], channel: field.split(",")[1], isHost: false,)));
      }
    });

  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

