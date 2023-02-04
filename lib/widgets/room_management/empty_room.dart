import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakan/constants/colors_manager.dart';
import 'package:sakan/constants/images_manager.dart';

Widget emptyRoom(BuildContext context){
  return Column(
    children: [
     Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: ColorsManager.whiteColor,
      ),
      child: Center(
        child: SvgPicture.asset(
          ImagesManager.rooms,
        )
      ),
     )
    ],
  );
}