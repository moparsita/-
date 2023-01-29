import 'package:flutter/material.dart';
import 'package:red_leaf/Globals/Globals.dart';
import 'package:red_leaf/Utils/color_utils.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final int radius;

  const ShimmerWidget({
    Key? key,
    required this.height,
    required this.width,
    this.radius = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Globals.darkModeStream.getStream,
      builder: (context, snapshot) {
        return Shimmer.fromColors(
          baseColor: ColorUtils.gray,
          highlightColor: ColorUtils.white,
          child: Container(
            decoration: BoxDecoration(
              color: ColorUtils.white,
              borderRadius: BorderRadius.circular(radius.toDouble()),
            ),
            height: height,
            width: width,
          ),
        );
      }
    );
  }
}
