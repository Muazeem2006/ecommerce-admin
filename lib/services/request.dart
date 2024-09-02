// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

final dio = Dio();
// String host = "http://192.168.8.111";  //AphzolVirusMesh
String host = "http://192.168.122.123"; //Godswill A04
String port = "3000";

Future<Response> get(String url, [dynamic data]) async {
  url = "$host:$port/$url";
  print(url);
  final Response response = await dio.get(url, queryParameters: data);
  print(response.data);
  return response;
}

Future<Response> post(String url, dynamic data) async {
  url = "$host:$port/$url";
  print(url);
  final Response response = await dio.post(url, data: data);
  return response;
}
