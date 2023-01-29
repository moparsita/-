import 'package:red_leaf/Globals/Globals.dart';
import 'package:red_leaf/Models/user_model.dart';
import 'package:red_leaf/Utils/Api/project_request_utils.dart';
import 'package:red_leaf/Utils/routing_utils.dart';
import 'package:red_leaf/Utils/storage_utils.dart';

import '../../Plugins/get/get.dart';

class SplashController extends GetxController {
  final RxBool isLoaded = false.obs;

  void onInit() {
    Future.delayed(const Duration(seconds: 3), () async {
      String token = "no_token";

      // try {
      //   FirebaseMessaging messaging = FirebaseMessaging.instance;
      //   token = await messaging.getToken() ?? "no_token";
      //   print(token);
      // } catch (e) {
      //   print(e.toString());
      // }
      ApiResult result = await RequestsUtil.instance.auth.check(token);
      if (result.isDone){
        Globals.userStream.changeUser(UserModel.fromJson(result.data['user']));
        Get.offAndToNamed(
          RoutingUtils.main.name,
        );
        return true;
      }
      Get.offAndToNamed(
        RoutingUtils.login.name,
      );
    });
    super.onInit();
  }
}
