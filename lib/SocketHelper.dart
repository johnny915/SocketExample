import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pdfdemo/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'Screen/CallingScreen.dart';
import 'firebase_options.dart';

class SocketHelper {

  static final SocketHelper _instance = SocketHelper._internal();
  factory SocketHelper() {
    return _instance;
  }

  SocketHelper._internal();


   Socket? socket;

  void initSocket(){

    notificationService.showNotification(888, "Test","Connecting to server","");
      socket = io('http://192.168.1.119:8081',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build()
    );
      socket!.on('connect', (_) async{
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
        try{
          if(FirebaseAuth.instance.currentUser!=null){
            userRef.doc(authInst.currentUser!.uid).update({"socketId":socket!.id!}).then((value) {
              notificationService.showNotification(888, "Test","Token added to firebase","");
            });
          }
          notificationService.showNotification(888, "Test","connected","");
        }catch(e){
          notificationService.showNotification(888, "Test","Failed $e","");
        }

      });

      socket!.onConnectError((data) {
        notificationService.showNotification(888, "Test","Failed  to connect server","");
        print(data);
        initSocket();
      });




    socket!.connect();






  }

}