import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) async {
      final response = await  http.post(url,
        headers: {
          'Accept':'application/json'
        },
        body: body ) ;
    // var status = response.body.contains('error');
    var status = response.statusCode;

    var data = json.decode(response.body);
    
    if(status==403){
      return data;
    }else{
      return data["token"];
    }
  

    // return http
    //     .post(url, body: body, headers: headers, encoding: encoding)
    //     .then((http.Response response) {
    //   final String res = response.body;
    //   final int statusCode = response.statusCode;

    //   if (statusCode < 200 || statusCode > 400 || json == null) {
    //     throw new Exception("Error while fetching data");
    //   }
    //   return _decoder.convert(res);
    // });
  }

    //  loginData(String email , String password) async{

    // String myUrl = "$serverUrl/login1";

    // }

}