import 'package:flutter/material.dart';
import 'package:pdfdemo/main.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'Screen/CallingScreen.dart';

class SocketHelper {
  late Socket socket;
  String _socketId= "";

  String get socketId => _socketId;


  void initSocket(){
     socket = io('http://192.168.1.21:8081',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build()
    );
    socket.connect();
     socket.on('connect', (_) {
       _socketId = socket.id!;
       socketHelper.socket.on('incoming_call_event', (data) {
        Navigator.push(navigatorKey.currentState!.context, MaterialPageRoute(builder: (context) =>  CallingScreen( token: data['token'], channel: data['chanel_name'], isHost: false,)));
       });
       if(authInst.currentUser!=null){
         userRef.doc(authInst.currentUser!.uid).update({"socketId":_socketId});
       }
     });
  }

}