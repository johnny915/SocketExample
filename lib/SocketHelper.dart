import 'package:pdfdemo/main.dart';
import 'package:socket_io_client/socket_io_client.dart';

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

    socket.onConnect((_) {
      _socketId = socket.id!;
      if(authInst.currentUser!=null){
        userRef.doc(createdUser!.uid).update({"socketId":_socketId});
      }
    });
  }

}