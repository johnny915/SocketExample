import 'package:flutter/material.dart';
import 'package:pdfdemo/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'Screen/CallingScreen.dart';

class SocketHelper {

  static final SocketHelper _instance = SocketHelper._internal();
  factory SocketHelper() {
    return _instance;
  }

  SocketHelper._internal();


  late Socket socket;

  void initSocket(){
      socket = io('http://192.168.1.21:8081',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build()
    );
    socket.connect();

     socket.onConnectError((data) {
       print(data);
     });



     socket.on('connect', (_) async{
       SharedPreferences prefs = await SharedPreferences.getInstance();
       await prefs.setString('socket_id', socket.id!);
       if(authInst.currentUser!=null){
         userRef.doc(authInst.currentUser!.uid).update({"socketId":socket.id!}).then((value) {
           print("socket added to server");
         });
       }
       socketHelper.socket.on('incoming_call_event', (data) {
        Navigator.push(navigatorKey.currentState!.context, MaterialPageRoute(builder: (context) =>  CallingScreen( token: data['token'], channel: data['chanel_name'], isHost: false,)));
       });
     });
  }

}