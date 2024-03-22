// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:math';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import './apiurl.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart' hide Response;

class HttpUtil {
  static late HttpUtil _instance;
  late Dio dio;
  late BaseOptions options;

  late CancelToken cancelToken = CancelToken();

  static HttpUtil getInstance() {
    _instance ??= HttpUtil();
    return _instance;
  }

  /*
   * config it and create
   */
  HttpUtil() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    options = BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: "http://123456",
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: 6000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 6000,
      //Http请求头.
      headers: {
        'Api-Version': '1.1',
        'Accept': "application/json",
        "Content-Type": "application/json",
      },
      //请求的Content-Type，默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
      // contentType: Headers.jsonContentType,
      //表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      // responseType: ResponseType.json,
    );

    dio = Dio(options);

    //Cookie管理
    dio.interceptors.add(CookieManager(CookieJar()));
    //打开日志
    dio.interceptors.add(LogInterceptor(responseBody: true));
    //添加拦截器
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint("请求之前");
        //添加token
        GetStorage box = GetStorage();
        var token = box.read("token");
        if (token != null && token.isNotEmpty) {
          //options.headers['token'] =
          //"w70xEQ3RS/eVpFrM2oMNDodGKxZKNntGRYWenrV+3Ik="; //token;
        }
        options.headers['token'] = "1234567890";
        handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint("响应之前");
        if (response.data['code'].toString() == '401') {
          debugPrint('登录过期被拦截到了');
          //token过期，跳转到登录并清空缓存
          GetStorage box = GetStorage();
          box.erase();
          // Get.offAllNamed('/login');
          // Fluttertoast.showToast(msg: "登录已过期");
          handler.reject(response.data["msg"]);
        }
        // if (response.data['code'].toString() != '200') {
        //   handler.reject(response.data["msg"]);
        // }
        handler.next(response);
      },
      onError: (error, handler) {
        debugPrint("错误之前");
        handler.next(error);
      },
    ));
  }

  /*
   * get请求
   */
  get(url, {data, options, cancelToken}) async {
    Response? response;
    try {
      response = await dio.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
      // debugPrint('get success---------${response.data}');
//      response.data; 响应体
//      response.headers; 响应头
//      response.request; 请求体
//      response.statusCode; 状态码
    } on DioError catch (e) {
      debugPrint('get error---------$e');
      formatError(e);
    }

    return response;
  }

  /*
   * post请求
   */
  post(url, {data, options, cancelToken}) async {
    Response? response;
    try {
      response = await dio.post(url,
          data: data, options: options, cancelToken: cancelToken);
      debugPrint('post success---------${response.data}');
    } on DioError catch (e) {
      debugPrint('post error---------$e');
      formatError(e);
    }
    return response;
  }

  /*
   * 下载文件
   */
  downloadFile(urlPath, savePath) async {
    Response? response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
        debugPrint("$count $total");
      });
      debugPrint('downloadFile success---------${response.data}');
    } on DioError catch (e) {
      debugPrint('downloadFile error---------$e');
      formatError(e);
    }
    return response!.data;
  }

  /*
   * error统一处理
   */
  formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      // It occurs when url is opened timeout.
      debugPrint("连接超时");
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      debugPrint("请求超时");
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      debugPrint("响应超时");
    } else if (e.type == DioErrorType.response) {
      // When the server response, but with a incorrect status, such as 404, 503...
      debugPrint("出现异常");
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      debugPrint("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      debugPrint("未知错误");
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
