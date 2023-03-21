import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:async';





@RestApi(baseUrl: "http://stonemen.bsninfotech.org/")
abstract class ApiService {
    factory ApiService(Dio dio, {required String baseUrl}){

      dio.options=BaseOptions(
        contentType: 'Application/json',

      );

      return ApiService(dio,baseUrl:baseUrl);
    }



    //     ) = _ApiService;
    //
    // static ApiService create() {
    //   final dio = Dio();
    //
    // dio.interceptors.add(PrettyDioLogger( requestHeader: true,
    //     requestBody: true,
    //     responseBody: true,
    //     responseHeader: false,
    //     error: true,
    //     compact: true,
    //     maxWidth: 90));
    // return ApiService(dio);
  // }



  @POST("api/LoginApi/UserAuthentication")
  Future<Response> getLogin(@Body() Map<String, dynamic> body);


}
