import 'dart:convert';
import 'dart:io';

import 'package:red_leaf/Utils/Api/WebControllers.dart';
import 'package:red_leaf/Utils/Api/project_request_utils.dart';

class DataApi {
  Future<ApiResult> about() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.data,
      webMethod: 'about-us',
      postRequest: false,
      auth: true,
    );
  }

  Future<ApiResult> invite() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.data,
      webMethod: 'invite',
      postRequest: false,
      auth: true,
    );
  }
  Future<ApiResult> support() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.data,
      webMethod: 'support',
      postRequest: false,
      auth: true,
    );
  }
  Future<ApiResult> guide() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.data,
      webMethod: 'guide',
      postRequest: false,
      auth: true,
    );
  }

  Future<ApiResult> faq() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.data,
      webMethod: 'host-questions',
      postRequest: false,
      auth: true,
    );
  }

  Future<ApiResult> drawerData() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.data,
      webMethod: 'drawer-data',
      postRequest: false,
      auth: true,
    );
  }


}
