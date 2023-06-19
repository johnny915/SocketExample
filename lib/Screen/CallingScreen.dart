import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

class CallingScreen extends StatefulWidget {
  String token,channel;
  bool isHost;
  CallingScreen({Key? key,required this.isHost,required this.token,required this.channel}) : super(key: key);

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  RtcEngine? _engine;


  @override
  void dispose() {
    super.dispose();
    _engine!.leaveChannel();
    _engine!.release(sync: true);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,()async{
      try{

      }catch(e){
        print(e.toString());
      }
      await initAgora();
    });
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    _engine!.initialize( const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ))
        .then((value) async{
      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint("local user ${connection.localUid} joined");
            setState(() {
              _localUserJoined = true;
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint("remote user $remoteUid joined");
            setState(() {
              _remoteUid = remoteUid;
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            debugPrint("remote user $remoteUid left channel");
            _engine!.leaveChannel();
            Navigator.pop(context);
          },
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
            debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
          },
        ),
      );


      await _engine!.setClientRole(role: widget.isHost ? ClientRoleType.clientRoleBroadcaster : ClientRoleType.clientRoleAudience);
      await _engine!.enableVideo();


      await _engine!
          .joinChannel(

        //token: "007eJxTYJjEvn2CesLiJ4biuxXNw6RerS8xCevkbo8+9f2HULio014FBlPjFMOklFTzxDRDAxMzyzQLU4vktMS0lOQkUzPDRFPzSfw9KQ2BjAxu1yIZGKEQxLdgCLM09olyDIzMsAxLs7AwCE8NDqwozfepcorwNE43MHcv8g8LrCoOTYkISrT09SwuL84M9gn0MDViYAAAuLMuxA==",
        channelId: widget.channel,
        uid: 0,
        options: const ChannelMediaOptions(), token: widget.token,
      )
          .then((value) {
        print("Success");
      }).catchError((onError) {
        print("kasim" + onError.toString());
      });
    });

    // view = true;
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                  child:  _localUserJoined ? AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine!,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                    onAgoraVideoViewCreated: (viewId) {
                      _engine!.startPreview();
                    },
                  )
                      : const CircularProgressIndicator()

              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Align(
              alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height:50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(100)
                        //more than 50% of width makes circle
                      ),
                      child: IconButton(
                        onPressed: (){

                        },
                        icon: const Icon(Icons.mic,color: Colors.blue,),
                      ),
                    ),
                    Container(
                      height:50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(100)
                        //more than 50% of width makes circle
                      ),
                      child: IconButton(
                        onPressed: (){
                          _engine!.leaveChannel();
                          _engine!.release(sync: true);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.call_end_outlined,color: Colors.white,),
                      ),
                    ),
                    Container(
                      height:50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(100)
                        //more than 50% of width makes circle
                      ),
                      child: IconButton(
                        onPressed: (){
                         _engine!.switchCamera();
                        },
                        icon: const Icon(Icons.cameraswitch_sharp,color: Colors.blue,),
                      ),
                    ),
                  ],
                )
            ),
          )
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: _remoteUid),
          connection:   RtcConnection(channelId: widget.channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
