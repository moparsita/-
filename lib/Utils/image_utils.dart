import 'package:flutter/material.dart';
import 'package:red_leaf/Utils/color_utils.dart';

class ImageUtils {
  static String logo = 'assets/img/logo.png';
  static String character = 'assets/img/character.png';
  static String banner = 'assets/img/banner.jpg';
  static String logo2 = 'assets/img/logo_2.png';
  static String launcher = 'assets/img/launcher.png';

  static AssetImage placeholder = const AssetImage(
    'assets/animations/image.gif',
  );

  static ImageErrorWidgetBuilder errorBuilder = (
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Image.asset(
      ImageUtils.placeholder.assetName,
      height: double.maxFinite,
      width: double.maxFinite,
      fit: BoxFit.cover,
    );
  };

  static FadeInImage fadeIn({
    required String image,
    double? width,
    double? height,
  }) {
    return FadeInImage(
      placeholder: ImageUtils.placeholder,
      imageErrorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        return Image.asset(
          ImageUtils.placeholder.assetName,
          width: width,
          height: height,
          color: ColorUtils.white.withOpacity(0.8),
          colorBlendMode: BlendMode.darken,
          fit: BoxFit.cover,
        );
      },
      image: NetworkImage(
        image,
      ),
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  static Widget marker() {
    return Image.asset(
      'assets/img/marker.png',
      width: 25,
      fit: BoxFit.scaleDown,
      height: 25,
    );
  }
}
