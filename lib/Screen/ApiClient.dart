import 'package:dio/dio.dart';

import '../Helper.dart';
import '../main.dart';

class DioClient {
  final Dio _dio = Dio();
  final baseUrl = 'http://192.168.1.21:8081/';


  Future<String> genToken(String target) async {

    Response userData = await _dio.get('$baseUrl/token',queryParameters:{
      "channel_name":getChanelName(target: target),
      "uid":createdUser!.uid
    });

    // Prints the raw data returned by the server
    print('User Info: ${userData.data}');


    return "";
  }
}