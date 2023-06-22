import 'dart:convert';

import 'package:agora_token_service/agora_token_service.dart';
import 'package:flutter/material.dart';

import 'Model/UserModel.dart';
import 'Screen/SplashScreen.dart';
import 'main.dart';

Future<UserModel>  getUserFromUid(String id) async{
  UserModel? user;
  try{
    final data = await userRef.doc(id).get();
    user = UserModel.fromJson(data.data()!);
    print(jsonEncode(user));
  }catch(e){
    print(e.toString());
  }
  return user!;
}


String getChanelName({required String target}){
  List list = [createdUser!.uid,target];
  list.sort();
  return list.join();
}

String createToken({required String targetUid,required RtcRole role}){
  String token = "";

  List list = [createdUser!.uid,targetUid];
  list.sort();

   token = RtcTokenBuilder.build(
    appId: appId,
    appCertificate: appCertificate,
    channelName: list.join(),
    uid: createdUser!.uid,
    role: role,
    expireTimestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000+3600,
  );
  return "$token,${list.join()}";
}

logout() async {
  await authInst.signOut();
  createdUser = null;
 // service.invoke("stopService");
  Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SplashScreen()),
          (Route<dynamic> route) => false);
}

