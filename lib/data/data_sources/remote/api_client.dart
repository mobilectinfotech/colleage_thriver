import 'package:colleage_thriver/core/utils/progress_dialog_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:colleage_thriver/data/data_sources/remote/apI_endpoint_urls.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/network_info.dart';
import '../../../routes/app_routes.dart';

class ApiClient {
  late Dio dio;
  late BaseOptions baseOptions;

  ApiClient() {
    baseOptions = BaseOptions(
        receiveTimeout: Duration(seconds: 30),
        connectTimeout: Duration(seconds: 30),
        baseUrl: AppUrls.mainUrl);
    dio = Dio(baseOptions);
    dio.interceptors
        .add(PrettyDioLogger(requestBody: true, requestHeader: true));
  }

  // getRequest

  Future<Response> getRequest({required String endPoint}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final options =
    //user id 13
    //   Options(headers: {"Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEzLCJpYXQiOjE3MTU2MTQ1Mjh9.laQ3SKA0Y7S5GRFfvA-X41aT1azY6YOqYurgXnscJhs"});
      //Options(headers: {"Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjYsImVtYWlsIjoiZ3JlZW5zMUBtYWlsaW5hdG9yLmNvbSIsImlhdCI6MTcxMjgxODk4NSwiZXhwIjoxNzEzMDc4MTg1fQ.oMUJ_DoiFgZdfrPlk0stJUvumd_QNK_SkjMelJaphh0"});
     Options(headers: {"Authorization": "Bearer ${prefs.get("token")}"});
    try {
      var response = await dio.get(endPoint, options: options);
      return response;
    } on DioException catch (e) {
      return createErrorEntity(e);
    }
  }

  Future<Response> postRequest(
      {required String endPoint, required dynamic body}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final options =
    // Options(headers: {"Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEzLCJpYXQiOjE3MTU2MTQ1Mjh9.laQ3SKA0Y7S5GRFfvA-X41aT1azY6YOqYurgXnscJhs"});

    Options(headers: {"Authorization": "Bearer ${prefs.get("token")}"});
     //   Options(headers: {"Authorization": "Bearer ${prefs.get("token")}"});
    try {
      var response = await dio.post(endPoint, data: body, options: options);
      return response;
    } on DioException catch (e) {
      return createErrorEntity(e);
    }
  }
}

Future<Response>  createErrorEntity(DioException error) async {
  print("asdfasdf{t${error.type}");
  print("asdfasdf{t${error.response}");
  print("asdfasdf{t${error.response}");
  switch (error.type) {
    case DioExceptionType.badResponse:
      switch (error.response!.statusCode) {
        case 400:
          print("sdfghsdfsdf");
           return error.response!;

        case 401:
          print("AppRoutes. loginScreen");
          Get.offAllNamed(AppRoutes.loginScreen);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', false);
          return error.response!;
        case 404:
          return Response(data: {
            'message': 'Url Not Found',
            "statusCode": 404,
          }, statusCode: 404, requestOptions: RequestOptions());
        case 500:
          return error.response!;
      }
      return error.response!;

    case DioExceptionType.connectionTimeout:
      return Response(data: {
        'message': 'Connection timed out',
        "statusCode": -1,
      }, statusCode: -1, requestOptions: RequestOptions());

    case DioExceptionType.sendTimeout:
      return Response(data: {
        'message': 'Send timed out',
        "statusCode": -2,
      }, statusCode: -2, requestOptions: RequestOptions());

    case DioExceptionType.receiveTimeout:
      return Response(data: {
        'message': 'Receive timed out',
        "statusCode": -3,
      }, statusCode: -3, requestOptions: RequestOptions());

    case DioExceptionType.badCertificate:
      return Response(data: {
        'message': 'Bad SSL certificates',
        "statusCode": -4,
      }, statusCode: -4, requestOptions: RequestOptions());

    case DioExceptionType.cancel:
      return Response(data: {
        'message': 'Server canceled it',
        "statusCode": -5,
      }, statusCode: -5, requestOptions: RequestOptions());

    case DioExceptionType.connectionError:
      return Response(data: {
        'message': 'Connection error',
        "statusCode": -6,
      }, statusCode: -6, requestOptions: RequestOptions());

    case DioExceptionType.unknown:
      return Response(data: {
        'message': 'Unknown error',
        "statusCode": -7,
      }, statusCode: -7, requestOptions: RequestOptions());

    default:
      return Response(data: {
        'message': 'Unknown error',
        "statusCode": -8,
      }, statusCode: -8, requestOptions: RequestOptions());
  }
}

Future<void> checkInternetConnectivity(NetworkInfo networkInfo) async {
  bool isConnected = await networkInfo.isConnected();
  print('Internet connected: $isConnected');
}

void listenForConnectivityChanges(NetworkInfo networkInfo) {
  networkInfo.onConnectivityChanged.listen((ConnectivityResult result) {
    print('Connectivity status changed: $result');
  });
}

Future<bool> checkInternetConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}