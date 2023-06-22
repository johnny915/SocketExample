import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pdfdemo/Screen/ApiClient.dart';
import 'package:pdfdemo/SocketHelper.dart';

import 'Model/UserModel.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
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
final service = FlutterBackgroundService();
String socketId= "";
const appId = "53d1bde7af10469f858cfafdcb561a57";
const appCertificate = "e0acdc5d4cec48f28ea17fb702ddeada";

UserModel? createdUser;
SocketHelper socketHelper = SocketHelper();
late DioClient client;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) {
    initializeService().whenComplete(() {
        service.startService();
    });
  });
  client = DioClient();


  // if(authInst.currentUser!=null){
  //   userRef.doc(authInst.currentUser!.uid).snapshots().listen((querySnapshot) {
  //
  //     String field =querySnapshot.get("caller");
  //     if(field!=""){
  //      Navigator.push(navigatorKey.currentState!.context, MaterialPageRoute(builder: (context) =>  CallingScreen( token: field.split(",")[0], channel: field.split(",")[1], isHost: false,)));
  //     }
  //   });
  //
  // }


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
      home: const SplashScreen(),
    );
  }
}

Future<void> initializeService() async {




  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}


Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
    socketHelper.initSocket();
  // bring to foreground
  // Timer.periodic(const Duration(seconds: 1), (timer) async {
  //   if (service is AndroidServiceInstance) {
  //     if (await service.isForegroundService()) {
  //       // if you don't using custom notification, uncomment this
  //       service.setForegroundNotificationInfo(
  //         title: "My App Service",
  //         content: "Updated at ${DateTime.now()}",
  //       );
  //     }
  //   }
  //
  //
  //   /// you can see this log in logcat
  //   print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()} ${socketHelper.socketId}');
  //
  //   service.invoke(
  //     'update',
  //     {
  //       "current_date": DateTime.now().toIso8601String(),
  //       "device": "",
  //     },
  //   );
  // });
}
