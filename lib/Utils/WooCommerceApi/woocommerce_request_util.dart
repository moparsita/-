
import 'dart:convert';

import 'package:red_leaf/Globals/Globals.dart';
import 'package:red_leaf/Utils/WooCommerceApi/wDataApi.dart';

import '../../Plugins/get/get_connect/connect.dart';

class WooCommerceUtil extends GetConnect {
  static WooCommerceUtil instance = WooCommerceUtil();
  wDataApi data = wDataApi();
  static String baseRequestUrl = Globals.userStream.user!.website + '/wp-json/wc/v3/';
  static String consumerKey = Globals.userStream.user!.consumerKey;
  static String consumerSecret = Globals.userStream.user!.consumerSecret;

  String _makePath(String webMethod) {
    return "${WooCommerceUtil.baseRequestUrl}${webMethod.toString()}";
  }

  Future<wApiResult> wooCommerceRequest({
    required String webMethod,
    Map<String, dynamic> body = const {},
    required Map<String, dynamic> params,
    Map<String, String>? headers,
    bool auth = false,
    String RequestType = "post",
    void Function(double value)? onData,
  }) async {
    String url = _makePath(webMethod);
    late Response response;
    params["consumer_key"] = WooCommerceUtil.consumerKey;
    params["consumer_secret"] = WooCommerceUtil.consumerSecret;

    print("Request url: $url\n\nRequest params: ${jsonEncode(params)}\n\nRequest Data: ${jsonEncode(body)}\nRequest type: ${RequestType}\n");
    FormData formData = FormData(
      body,
    );
    if (RequestType == "post") {
      response = await post(
        url,
        formData,
        uploadProgress: onData,
        headers: headers,
        query: params,
      );
    } else if (RequestType == "put") {
      response = await put(
        url,
        body,
        uploadProgress: onData,
        headers: headers,
        query: params,

      );
    } else {
      response = await get(
        url,
        headers: headers,
        query: params,
      );
    }
    wApiResult apiResult = wApiResult();
    print(response.body);
    print(response.statusCode);
    apiResult.status = response.statusCode ?? 0;
    apiResult.isDone = response.statusCode?.toString().split('').first == '2';
    // if (response.statusCode == 200) {
    if (response.statusCode == 403) {
      Globals.loginDialog();
      return apiResult;
    }
    try {
      apiResult.data = response.body;
      apiResult.requestedMethod = "$WooCommerceUtil.baseRequestUrl $webMethod";
    } catch (e) {
      print(e);
      apiResult.isDone = false;
      apiResult.requestedMethod = webMethod.toString().split('.').last;
      apiResult.data = response.body;
    }
    return apiResult;
  }

}

class wApiResult {
  late bool isDone;
  int status = 0;
  String? requestedMethod;
  dynamic data;

  wApiResult({
    this.isDone = false,
    this.requestedMethod,
    this.data,
    this.status = 0,
  });
}