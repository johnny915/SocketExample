import 'dart:convert';

import 'package:agora_token_service/agora_token_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdfdemo/SocketHelper.dart';

import '../Helper.dart';
import '../Model/UserModel.dart';
import '../main.dart';
import 'CallingScreen.dart';
import 'SplashScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

 @override
  void initState() {
    super.initState();
    service.on('HomeScreen_Callback').listen((event) {
      print(event);

      // Get.to(CallingScreen( token: event!["token"], channel: event["chanel_name"], isHost: true,));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Users",),
            foregroundColor: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
          IconButton(onPressed: (){
            logout();
          }, icon: const Icon(Icons.login))
        ],),
        body: StreamBuilder(
          stream: userRef.snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasData){
              return userList(snapshot);
            }
            else{
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }


  Widget userList(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    List<UserModel> users = [];
    for(int i = 0 ;i<snapshot.data!.docs.length;i++){
      var  e = snapshot.data!.docs[i].data() as Map<String,dynamic>;
       if(e['uid']!=createdUser!.uid){
         users.add(UserModel.fromJson(e));
       }
      print(jsonEncode(users));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 500,
        child: ListView.separated(
          itemCount: users.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return  ListTile(
              leading: const Icon(Icons.person),
              title: Text(users[index].userName),
              tileColor: Colors.blueGrey,
              trailing: IconButton(
                onPressed: () async{


                   client.genToken( users[index].uid).then((value) {
                     service.invoke(
                       'make_call',
                       {
                         "id":users[index].socketId,
                         "token":value,
                         "chanel_name":getChanelName(target: users[index].uid)
                       },
                     );
                   });


                  // SocketHelper().socket!.emit('calling', {
                  //   "id":users[index].socketId,
                  //   "token":token,
                  //   "chanel_name":getChanelName(target: users[index].uid)
                  // });
                  //
                  // Navigator.push(context, MaterialPageRoute(builder: (context) =>  CallingScreen( token: token, channel: getChanelName(target: users[index].uid), isHost: true,)));
                },
                icon: const Icon(Icons.call,color: Colors.green,),
              ),
              onTap: (){
              //  Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserProfile(uid: users[index].uid)));
              },
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),

            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 5,);
          },
        ),
      ),
    );
  }


}
