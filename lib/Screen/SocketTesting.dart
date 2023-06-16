import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketTesting extends StatefulWidget {
  const SocketTesting({Key? key}) : super(key: key);

  @override
  State<SocketTesting> createState() => _SocketTestingState();
}

class _SocketTestingState extends State<SocketTesting> {

final controller = TextEditingController();
late Socket socket;
String rec = "";

  @override
  void initState() {
    super.initState();




    socket.on('receive_message', (data) {
      print("data from server ");
      print(data);
      rec = data;
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
                TextFormField(
                  controller: controller,
                ),
            ElevatedButton(onPressed: (){
              socket.emit('send_message', {
                "id":socket.id,
                "message":controller.text.trim()
              });
              controller.text = "";
            }, child: const Text("Send")),
            Text(rec)
          ],
        ),
      ),
    );
  }
}
