import 'package:dio/dio.dart';

import '../Helper.dart';
import '../main.dart';

class DioClient {
  final Dio _dio = Dio();
  final baseUrl = 'http://172.19.48.1:8081';

  Future<String> genToken(String target) async {
  String token = "";
   try{
     Response userData = await _dio.get('$baseUrl/token',queryParameters:{
       "channel_name":getChanelName(target: target),
       "uid":0
     });

     token = userData.data['token'];
     // Prints the raw data returned by the server
     print('User Info: ${userData.data}');
   }catch(e){
     print(e.toString());
   }


    return token;
  }
}