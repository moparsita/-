import 'dart:convert';

import 'package:red_leaf/Utils/Api/WebControllers.dart';
import 'package:red_leaf/Utils/Api/project_request_utils.dart';
import 'package:image_picker/image_picker.dart';

class AuthApi {
  Future<ApiResult> init({
    required String mobile,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'init',
      postRequest: true,
      body: {
        'mobile': mobile,
      },
    );
  }

  Future<ApiResult> forgotPassword({
    required String mobile,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'forgot',
      postRequest: true,
      body: {
        'mobile': mobile,
      },
    );
  }

  Future<ApiResult> validate({
    required String mobile,
    required String code,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'validate',
      postRequest: true,
      auth: true,
      body: {
        'mobile': mobile,
        'code': code,
      },
    );
  }

  Future<ApiResult> login({
    required String mobile,
    required String password,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'login',
      postRequest: true,
      auth: true,
      body: {
        'mobile': mobile,
        'password': password,
      },
    );
  }

  Future<ApiResult> check(String token) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'check/$token',
      postRequest: false,
      auth: true,
    );
  }

  Future<ApiResult> completeRegister({
    required String name,
    required String lastName,
    required String password,
    required String passwordConfirm,
    required String code,
    required String mobile,
    required String website,
    required String consumerKey,
    required String consumerSecret,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'register',
      postRequest: true,
      auth: true,
      body: {
        'name': name,
        'lastName': lastName,
        'password': password,
        'code': code,
        'mobile': mobile,
        'website': website,
        'consumerKey': consumerKey,
        'consumerSecret': consumerSecret,
      },
    );
  }

  Future<ApiResult> updateImage(XFile file) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'update-image',
      postRequest: true,
      auth: true,
      body: {
        'image': base64Encode(await file.readAsBytes()),
      },
    );
  }
  Future<ApiResult> updateNationalCard(XFile file) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'update-id',
      postRequest: true,
      auth: true,
      body: {
        'image': base64Encode(await file.readAsBytes()),
      },
    );
  }

  Future<ApiResult> updateProfile({
    required String firstName,
    required String lastName,
    required String website,
    required String consumerKey,
    required String consumerSecret,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'update-profile',
      postRequest: true,
      auth: true,
      body: {
        'firstName': firstName.toString(),
        'lastName': lastName.toString(),
        'website': website.toString(),
        'consumerKey': consumerKey.toString(),
        'consumerSecret': consumerSecret.toString(),

      },
    );
  }
}
